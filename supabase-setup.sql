-- ============================================================
--  Vokabeltrainer – Datenbank einrichten
--  Supabase → SQL Editor → New query → alles einfügen → Run
--
--  Datenmodell:
--    learners   = Lernprofile (ein Eintrag pro Kind)
--    vocab      = Vokabeln, jeweils einem Kind zugeordnet
--    progress   = Lernstand je Kind, Vokabel und Richtung (Leitner-Fach)
--    app_state  = Punkte, Serie, Tagesziel je Kind
--  Zugriff: nur das (einzige) Familien-Konto, öffentliche Registrierung aus.
-- ============================================================

create table if not exists public.learners (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  created_at  timestamptz not null default now()
);

create table if not exists public.vocab (
  id          uuid primary key default gen_random_uuid(),
  learner_id  uuid not null references public.learners(id) on delete cascade,
  lang        text not null,
  unit        text not null,
  term        text not null,          -- Fremdsprache
  translation text not null,          -- Deutsch
  note        text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create index if not exists vocab_learner_idx on public.vocab (learner_id, lang, unit);

create table if not exists public.progress (
  learner_id  uuid not null references public.learners(id) on delete cascade,
  vocab_id    uuid not null references public.vocab(id) on delete cascade,
  dir         text not null check (dir in ('fd', 'df')),   -- fd = Fremd→Deutsch, df = Deutsch→Fremd
  box         int  not null default 0,                      -- 0 = neu, 1–5 = Leitner-Fach
  due         date,
  correct     int  not null default 0,
  wrong       int  not null default 0,
  updated_at  timestamptz not null default now(),
  primary key (learner_id, vocab_id, dir)
);
create index if not exists progress_vocab_idx on public.progress (vocab_id);

create table if not exists public.app_state (
  learner_id  uuid primary key references public.learners(id) on delete cascade,
  state       jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

-- ---------- Zugriffsschutz (Row Level Security) ----------
alter table public.learners  enable row level security;
alter table public.vocab     enable row level security;
alter table public.progress  enable row level security;
alter table public.app_state enable row level security;

drop policy if exists "family_all" on public.learners;
drop policy if exists "family_all" on public.vocab;
drop policy if exists "family_all" on public.progress;
drop policy if exists "family_all" on public.app_state;
create policy "family_all" on public.learners  for all to authenticated using (true) with check (true);
create policy "family_all" on public.vocab     for all to authenticated using (true) with check (true);
create policy "family_all" on public.progress  for all to authenticated using (true) with check (true);
create policy "family_all" on public.app_state for all to authenticated using (true) with check (true);

revoke all on public.learners, public.vocab, public.progress, public.app_state from anon;
grant select, insert, update, delete on public.learners, public.vocab, public.progress, public.app_state to authenticated;
