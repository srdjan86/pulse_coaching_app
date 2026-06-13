# Supabase backend

Pulse uses Supabase for auth and the lesson catalog when `BACKEND=supabase`.

## What is wired today

| Feature | Mock (default) | Supabase |
|---------|----------------|----------|
| Auth | `MockAuthRepository` | `SupabaseAuthRepository` |
| Lesson catalog | `MockCoachingVideoRepository` | `SupabaseCoachingVideoRepository` |
| Saved lessons | `SharedPreferences` (local) | Local only (sync in a follow-up) |

CI and local dev keep `BACKEND=mock` so no credentials are required.

## Project setup

1. Create a project at [supabase.com](https://supabase.com).
2. Apply the migration in `supabase/migrations/20250613000000_create_lessons.sql`:
   - **Supabase CLI:** `supabase db push` (after `supabase link`)
   - **Dashboard:** SQL Editor → paste and run the migration file
3. Enable email/password auth under **Authentication → Providers** if you use login.
4. Copy **Project URL** and **anon public** key from **Project Settings → API**.

## App configuration

Set credentials per flavor (do not commit real keys to git):

```json
{
  "FLAVOR": "staging",
  "APP_NAME": "Pulse Staging",
  "BACKEND": "supabase",
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key"
}
```

Run:

```bash
flutter run --flavor staging -t lib/main_staging.dart \
  --dart-define-from-file=config/staging.json
```

Use the same pattern for `config/prod.json` with a separate Supabase project.

## Schema

`public.lessons` stores published coaching videos. IDs are stable slugs (e.g. `morning-mobility`) so they match mock data and saved-lesson references.

Row Level Security allows anonymous read of `published = true` rows.

## Next steps

- `user_saved_lessons` table + `SupabaseSavedLessonsRepository`
- Optional Supabase Storage for thumbnails
- Staging/prod Supabase projects per flavor
