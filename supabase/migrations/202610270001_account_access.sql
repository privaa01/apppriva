begin;

-- Private data permissions never depend on editable user metadata or a UI route.
create or replace function public.has_password_session()
returns boolean language sql stable security invoker set search_path = ''
as $$
  select exists (
    select 1
    from jsonb_array_elements(
      case when jsonb_typeof(auth.jwt()->'amr')='array'
        then auth.jwt()->'amr' else '[]'::jsonb end
    ) as method
    where method->>'method'='password'
  );
$$;
revoke all on function public.has_password_session() from public;
grant execute on function public.has_password_session() to anon, authenticated;

create table public.treatment_policies (
  version text primary key check (length(btrim(version))>0),
  body text not null check (length(btrim(body))>0),
  is_active boolean not null default false,
  is_test boolean not null default false,
  purposes text[] not null check (cardinality(purposes)>0)
);
create unique index one_active_treatment_policy on public.treatment_policies((is_active)) where is_active;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null check(length(btrim(name))>0)
);
create table public.authorization_evidence (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id),
  policy_version text not null references public.treatment_policies(version),
  action text not null check(action='account_signup'),
  authorized_at timestamptz not null default statement_timestamp(),
  unique(user_id,policy_version,action)
);

alter table public.treatment_policies enable row level security;
alter table public.profiles enable row level security;
alter table public.authorization_evidence enable row level security;
revoke all on public.treatment_policies, public.profiles, public.authorization_evidence from anon, authenticated;
grant select on public.treatment_policies to anon, authenticated;
grant select on public.profiles, public.authorization_evidence to anon, authenticated;
grant update(name) on public.profiles to authenticated;

create policy published_treatment_policy on public.treatment_policies
for select to anon, authenticated using(is_active);
create policy own_password_profile_read on public.profiles
for select to authenticated using(id=auth.uid() and public.has_password_session());
create policy own_password_profile_update on public.profiles
for update to authenticated using(id=auth.uid() and public.has_password_session())
with check(id=auth.uid() and public.has_password_session());
create policy own_password_evidence_read on public.authorization_evidence
for select to authenticated using(user_id=auth.uid() and public.has_password_session());

-- No client insert/delete permission and no mutation permission on evidence.
comment on table public.authorization_evidence is
'Registration declaration received by server; retention/deletion requires approved policy, not an arbitrary client write.';

commit;
