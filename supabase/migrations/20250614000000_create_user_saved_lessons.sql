-- Per-user saved lessons (synced when signed in on Supabase backend).

create table public.user_saved_lessons (
  user_id uuid not null references auth.users (id) on delete cascade,
  lesson_id text not null references public.lessons (id) on delete cascade,
  saved_at timestamptz not null default now(),
  primary key (user_id, lesson_id)
);

create index user_saved_lessons_user_id_idx on public.user_saved_lessons (user_id);

alter table public.user_saved_lessons enable row level security;

create policy "Users read own saved lessons"
  on public.user_saved_lessons
  for select
  using (auth.uid() = user_id);

create policy "Users insert own saved lessons"
  on public.user_saved_lessons
  for insert
  with check (auth.uid() = user_id);

create policy "Users delete own saved lessons"
  on public.user_saved_lessons
  for delete
  using (auth.uid() = user_id);
