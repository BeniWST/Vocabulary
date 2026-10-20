-- ============================================================
--  Vokabeltrainer – Umbau auf mehrere Familien
--  Supabase → SQL Editor → New query → alles einfügen → Run
--
--  WICHTIG: Ausführen, BEVOR ein zweites Konto angelegt wird.
--  Bestehende Profile werden dem ältesten Konto (eurem Familien-Konto)
--  zugeordnet. Das Skript kann gefahrlos mehrfach laufen.
-- ============================================================

-- 1) Jedes Profil bekommt einen Besitzer (= das Konto der Familie)
alter table public.learners
  add column if not exists owner_id uuid references auth.users(id) on delete cascade;
alter table public.learners alter column owner_id set default auth.uid();

update public.learners
   set owner_id = (select id from auth.users order by created_at asc limit 1)
 where owner_id is null;

alter table public.learners alter column owner_id set not null;
create index if not exists learners_owner_idx on public.learners (owner_id);

-- 2) Zugriff: jede Familie sieht nur ihre eigenen Profile und deren Daten
drop policy if exists "family_all" on public.learners;
drop policy if exists "family_all" on public.vocab;
drop policy if exists "family_all" on public.progress;
drop policy if exists "family_all" on public.app_state;
drop policy if exists "own_learners"  on public.learners;
drop policy if exists "own_vocab"     on public.vocab;
drop policy if exists "own_progress"  on public.progress;
drop policy if exists "own_app_state" on public.app_state;

create policy "own_learners" on public.learners for all to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

create policy "own_vocab" on public.vocab for all to authenticated
  using      (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())))
  with check (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())));

create policy "own_progress" on public.progress for all to authenticated
  using      (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())))
  with check (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())));

create policy "own_app_state" on public.app_state for all to authenticated
  using      (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())))
  with check (exists (select 1 from public.learners l where l.id = learner_id and l.owner_id = (select auth.uid())));

-- 3) Geteilte Units: Vokabellisten, die eine Familie für alle freigibt
--    (nur Vokabeln und ein Anzeigename – keine Kinder, kein Lernstand)
create table if not exists public.shared_units (
  id          uuid primary key default gen_random_uuid(),
  owner_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  shared_by   text not null,
  lang        text not null,
  unit        text not null,
  items       jsonb not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
alter table public.shared_units enable row level security;

drop policy if exists "shared_read"   on public.shared_units;
drop policy if exists "shared_insert" on public.shared_units;
drop policy if exists "shared_update" on public.shared_units;
drop policy if exists "shared_delete" on public.shared_units;
create policy "shared_read"   on public.shared_units for select to authenticated using (true);
create policy "shared_insert" on public.shared_units for insert to authenticated with check (owner_id = (select auth.uid()));
create policy "shared_update" on public.shared_units for update to authenticated
  using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
create policy "shared_delete" on public.shared_units for delete to authenticated using (owner_id = (select auth.uid()));

revoke all on public.shared_units from anon;
grant select, insert, update, delete on public.shared_units to authenticated;

-- Kontrolle: zeigt, welchem Konto welches Profil gehört
select l.name as profil, u.email as konto
  from public.learners l join auth.users u on u.id = l.owner_id
 order by u.email, l.name;
