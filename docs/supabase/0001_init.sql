-- ─────────────────────────────────────────────────────────────────────────────
-- rizo_quiz: initial schema.
-- Run this once in Supabase Studio → SQL Editor → Run.
--
-- Tables:
--   quiz_categories      — list of categories (multilingual)
--   quiz_questions       — questions with localized options
--   quiz_player_scores   — per-(user, category, week) best score; upsert-only
-- ─────────────────────────────────────────────────────────────────────────────

create extension if not exists "uuid-ossp";

-- ─── Categories ──────────────────────────────────────────────────────────────
create table if not exists public.quiz_categories (
    id           uuid primary key default uuid_generate_v4(),
    key          text        not null unique,
    name_ru      text        not null default '',
    name_uz      text        not null default '',
    name_en      text        not null default '',
    subtitle_ru  text        not null default '',
    subtitle_uz  text        not null default '',
    subtitle_en  text        not null default '',
    glyph        text        not null default '',
    sort_order   int         not null default 0,
    is_active    bool        not null default true,
    created_at   timestamptz not null default now()
);

create index if not exists quiz_categories_active_sort
    on public.quiz_categories (is_active, sort_order);

-- ─── Questions ───────────────────────────────────────────────────────────────
create table if not exists public.quiz_questions (
    id            uuid primary key default uuid_generate_v4(),
    category_id   uuid        not null references public.quiz_categories(id) on delete cascade,
    type          text        not null default 'multiple_choice'
                  check (type in ('multiple_choice', 'true_false')),
    question_ru   text        not null default '',
    question_uz   text        not null default '',
    question_en   text        not null default '',
    options_ru    jsonb       not null default '[]'::jsonb,
    options_uz    jsonb       not null default '[]'::jsonb,
    options_en    jsonb       not null default '[]'::jsonb,
    correct_index int         not null default 0,
    is_active     bool        not null default true,
    created_at    timestamptz not null default now()
);

create index if not exists quiz_questions_cat_active
    on public.quiz_questions (category_id, is_active);

-- ─── Player scores (per category, per week) ─────────────────────────────────
-- One row per (user_id, category_id, period_key). `period_key` = YYYY-MM-DD
-- of the Monday (UTC) of the relevant week. Client computes it on submit.
-- Submit logic: INSERT … ON CONFLICT DO UPDATE WHERE new_score > old_score.
create table if not exists public.quiz_player_scores (
    id             uuid primary key default uuid_generate_v4(),
    user_id        text        not null,
    user_name      text        not null default '',
    category_id    uuid        not null references public.quiz_categories(id) on delete cascade,
    period_key     text        not null,
    score          int         not null default 0,
    correct_count  int         not null default 0,
    avg_seconds    float8      not null default 0,
    updated_at     timestamptz not null default now(),
    constraint quiz_player_scores_unique
        unique (user_id, category_id, period_key)
);

create index if not exists quiz_player_scores_period_score
    on public.quiz_player_scores (period_key, score desc);

create index if not exists quiz_player_scores_user_period
    on public.quiz_player_scores (user_id, period_key);

-- ─── Row Level Security ──────────────────────────────────────────────────────
alter table public.quiz_categories     enable row level security;
alter table public.quiz_questions      enable row level security;
alter table public.quiz_player_scores  enable row level security;

drop policy if exists "quiz_categories_select_active" on public.quiz_categories;
create policy "quiz_categories_select_active"
    on public.quiz_categories
    for select
    to anon, authenticated
    using (is_active = true);

drop policy if exists "quiz_questions_select_active" on public.quiz_questions;
create policy "quiz_questions_select_active"
    on public.quiz_questions
    for select
    to anon, authenticated
    using (is_active = true);

drop policy if exists "quiz_player_scores_select_all" on public.quiz_player_scores;
create policy "quiz_player_scores_select_all"
    on public.quiz_player_scores
    for select
    to anon, authenticated
    using (true);

drop policy if exists "quiz_player_scores_insert_any" on public.quiz_player_scores;
create policy "quiz_player_scores_insert_any"
    on public.quiz_player_scores
    for insert
    to anon, authenticated
    with check (true);

drop policy if exists "quiz_player_scores_update_higher" on public.quiz_player_scores;
create policy "quiz_player_scores_update_higher"
    on public.quiz_player_scores
    for update
    to anon, authenticated
    using (true)
    with check (true);

-- Note: the UPSERT logic in `submitScore` uses
--   ON CONFLICT (user_id, category_id, period_key) DO UPDATE … WHERE EXCLUDED.score > ...
-- which guarantees only-higher writes regardless of RLS.

-- DELETE: nobody. UPDATE rule above is only reachable via ON CONFLICT path.
