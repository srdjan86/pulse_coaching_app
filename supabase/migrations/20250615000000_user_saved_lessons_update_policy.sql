-- Upsert on conflict can hit UPDATE; allow users to refresh saved_at on re-save.

create policy "Users update own saved lessons"
  on public.user_saved_lessons
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
