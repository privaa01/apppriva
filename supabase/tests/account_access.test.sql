-- Regression tests run against disposable synthetic fixtures only.
\set ON_ERROR_STOP on
begin;

do $$ begin
  if to_regclass('public.profiles') is null then
    raise exception 'profiles relation missing: migrations not implemented';
  end if;
  if to_regclass('public.authorization_evidence') is null then
    raise exception 'authorization_evidence relation missing';
  end if;
end $$;

-- Fixtures contain no real personal information.
insert into public.treatment_policies(version,body,is_active,is_test,purposes)
values ('sql-active','Política sintética',true,true,array['Saludo','Acceso']),
       ('sql-inactive','No publicar',false,true,array['Prueba']);

-- Valid signup writes all three records with server-derived identity and action.
insert into auth.users(id,email,raw_user_meta_data)
values ('10000000-0000-0000-0000-000000000001','sql-one@example.test',
        '{"name":"Sintético","policy_version":"sql-active","authorization_accepted":true}');
do $$ begin
 if (select count(*) from public.profiles where id='10000000-0000-0000-0000-000000000001')<>1
 or (select count(*) from public.authorization_evidence where user_id='10000000-0000-0000-0000-000000000001' and action='account_signup')<>1 then
  raise exception 'signup is not atomic';
 end if;
end $$;

-- Malformed/absent acceptance, blank name, and unavailable versions cannot create a user.
do $$
declare meta jsonb; failed boolean; candidate uuid;
begin
 foreach meta in array array[
  '{"name":"No","policy_version":"sql-active"}'::jsonb,
  '{"name":"No","policy_version":"sql-active","authorization_accepted":false}'::jsonb,
  '{"name":"No","policy_version":"sql-active","authorization_accepted":"true"}'::jsonb,
  '{"name":" ","policy_version":"sql-active","authorization_accepted":true}'::jsonb,
  '{"name":"No","policy_version":"missing","authorization_accepted":true}'::jsonb,
  '{"name":"No","policy_version":"sql-inactive","authorization_accepted":true}'::jsonb
 ] loop
  candidate=gen_random_uuid(); failed=false;
  begin
   insert into auth.users(id,email,raw_user_meta_data)
   values(candidate,'sql-invalid@example.test',meta);
  exception when check_violation then failed=true;
  end;
  if not failed or exists(select 1 from auth.users where id=candidate)
  or exists(select 1 from public.profiles where id=candidate)
  or exists(select 1 from public.authorization_evidence where user_id=candidate) then
   raise exception 'invalid registration must roll back all records';
  end if;
 end loop;
end $$;

-- Simulated evidence write failure rolls back profile and auth row too.
create function public.test_reject_evidence() returns trigger language plpgsql as $$
begin raise exception 'synthetic evidence failure' using errcode='23514'; end $$;
create trigger test_reject_evidence before insert on public.authorization_evidence
for each row execute function public.test_reject_evidence();
do $$ declare failed boolean=false; begin
 begin
  insert into auth.users(id,email,raw_user_meta_data)
  values('10000000-0000-0000-0000-000000000002','sql-rollback@example.test',
   '{"name":"Rollback","policy_version":"sql-active","authorization_accepted":true}');
 exception when check_violation then failed=true;
 end;
 if not failed or exists(select 1 from auth.users where id='10000000-0000-0000-0000-000000000002')
 or exists(select 1 from public.profiles where id='10000000-0000-0000-0000-000000000002') then
  raise exception 'evidence failure did not roll back signup';
 end if;
end $$;
drop trigger test_reject_evidence on public.authorization_evidence;
drop function public.test_reject_evidence();

-- Changing client metadata cannot rewrite accepted version/name/evidence.
update auth.users set raw_user_meta_data='{"name":"Changed","policy_version":"sql-inactive","authorization_accepted":false}'
where id='10000000-0000-0000-0000-000000000001';
do $$ begin
 if (select policy_version from public.authorization_evidence where user_id='10000000-0000-0000-0000-000000000001')<>'sql-active'
 or (select name from public.profiles where id='10000000-0000-0000-0000-000000000001')<>'Sintético' then
  raise exception 'metadata rewrote server evidence';
 end if;
end $$;

-- RLS checks use restricted roles, not database owner/service role.
set local role anon;
select set_config('request.jwt.claims','{"role":"anon"}',true);
do $$ begin
 if (select count(*) from public.treatment_policies where version='sql-active')<>1
 or exists(select 1 from public.treatment_policies where version='sql-inactive')
 or exists(select 1 from public.profiles) then raise exception 'visitor access boundary failed'; end if;
end $$;
reset role;
set local role authenticated;
select set_config('request.jwt.claims','{"sub":"10000000-0000-0000-0000-000000000001","role":"authenticated","amr":[{"method":"otp"}]}',true);
do $$ begin
 if exists(select 1 from public.profiles) or exists(select 1 from public.authorization_evidence)
 then raise exception 'OTP session read private data'; end if;
end $$;
select set_config('request.jwt.claims','{"sub":"10000000-0000-0000-0000-000000000001","role":"authenticated","amr":[{"method":"password"}]}',true);
do $$ begin
 if (select count(*) from public.profiles)<>1
 or (select count(*) from public.authorization_evidence)<>1 then raise exception 'own password session denied'; end if;
end $$;
update public.profiles set name='Saludo editado' where id='10000000-0000-0000-0000-000000000001';
do $$ declare denied boolean=false; begin
 begin
  update public.authorization_evidence set action='altered';
 exception when insufficient_privilege then denied=true;
 end;
 if not denied then raise exception 'client evidence update unexpectedly permitted'; end if;
end $$;
select set_config('request.jwt.claims','{"sub":"10000000-0000-0000-0000-000000000099","role":"authenticated","amr":[{"method":"password"}]}',true);
do $$ begin
 if exists(select 1 from public.profiles) or exists(select 1 from public.authorization_evidence)
 then raise exception 'other identity read private data'; end if;
end $$;
reset role;
rollback;
select 'account_sql_regressions_passed' as result;
