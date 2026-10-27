begin;

-- The trigger owner cannot log in, bypass RLS, mutate evidence, or create API users.
do $$ begin
  if not exists(select 1 from pg_roles where rolname='priva_account_writer') then
    create role priva_account_writer nologin noinherit;
  end if;
end $$;
grant usage on schema public to priva_account_writer;
grant select on public.treatment_policies to priva_account_writer;
grant insert on public.profiles, public.authorization_evidence to priva_account_writer;
create policy registration_policy_read on public.treatment_policies
for select to priva_account_writer using(is_active);
create policy registration_profile_write on public.profiles
for insert to priva_account_writer with check(true);
create policy registration_evidence_write on public.authorization_evidence
for insert to priva_account_writer with check(true);

create or replace function public.capture_account_signup()
returns trigger language plpgsql security definer set search_path = ''
as $$
declare
  accepted_version text;
  display_name text;
begin
  if new.raw_user_meta_data->'authorization_accepted' is distinct from 'true'::jsonb
  or jsonb_typeof(new.raw_user_meta_data->'name') is distinct from 'string'
  or jsonb_typeof(new.raw_user_meta_data->'policy_version') is distinct from 'string' then
    raise exception 'Registration declaration required' using errcode='23514';
  end if;
  display_name=btrim(new.raw_user_meta_data->>'name');
  if display_name='' then
    raise exception 'Name required' using errcode='23514';
  end if;
  select p.version into accepted_version from public.treatment_policies p
  where p.version=new.raw_user_meta_data->>'policy_version' and p.is_active;
  if accepted_version is null then
    raise exception 'Published policy required' using errcode='23514';
  end if;
  insert into public.profiles(id,name) values(new.id,display_name);
  insert into public.authorization_evidence(user_id,policy_version,action,authorized_at)
  values(new.id,accepted_version,'account_signup',statement_timestamp());
  return new;
end;
$$;
-- Moving ownership requires schema CREATE briefly, not permission during execution.
grant create on schema public to priva_account_writer;
alter function public.capture_account_signup() owner to priva_account_writer;
revoke create on schema public from priva_account_writer;
revoke all on function public.capture_account_signup() from public, anon, authenticated;

create trigger capture_priva_signup after insert on auth.users
for each row execute function public.capture_account_signup();

-- Only INSERT is observed: later editable metadata never rewrites evidence.
commit;
