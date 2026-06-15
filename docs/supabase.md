# Supabase backend

Pulse uses Supabase for auth and the lesson catalog when `BACKEND=supabase`.

## What is wired today

| Feature | Mock (default) | Supabase |
|---------|----------------|----------|
| Auth | `MockAuthRepository` | `SupabaseAuthRepository` |
| Lesson catalog | `MockCoachingVideoRepository` | `SupabaseCoachingVideoRepository` |
| Saved lessons | `SharedPreferences` (local) | Local when guest; Supabase sync when signed in |

CI and local dev keep `BACKEND=mock` so no credentials are required.

## Project setup

1. Create a project at [supabase.com](https://supabase.com).
2. Apply both migrations in order:
   - `supabase/migrations/20250613000000_create_lessons.sql`
   - `supabase/migrations/20250614000000_create_user_saved_lessons.sql`
   - **Supabase CLI:** `supabase db push` (after `supabase link`)
   - **Dashboard:** SQL Editor → paste and run each migration file
3. Enable email/password auth under **Authentication → Providers** if you use login.
4. Configure auth redirect URLs under **Authentication → URL configuration**:
   - **Site URL:** `pulsecoaching://auth/callback` (replaces the default `http://localhost:3000`)
   - **Redirect URLs:** add `pulsecoaching://auth/callback` (or `pulsecoaching://**` wildcard)
5. Copy **Project URL** and **publishable key** from **Project Settings → API**.

## App configuration

Set credentials per flavor (do not commit real keys to git):

```json
{
  "FLAVOR": "staging",
  "APP_NAME": "Pulse Staging",
  "BACKEND": "supabase",
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "your-anon-key",
  "SUPABASE_AUTH_REDIRECT_URL": "pulsecoaching://auth/callback"
}
```

`SUPABASE_AUTH_REDIRECT_URL` is optional; it defaults to `pulsecoaching://auth/callback`, which must match the deep link registered in the app and in Supabase Auth settings.

Run:

```bash
flutter run --flavor staging -t lib/main_staging.dart \
  --dart-define-from-file=config/staging.json
```

Use the same pattern for `config/prod.json` with a separate Supabase project.

## Email confirmation deep link

Sign-up emails include a verification link. The link uses a **technical callback URL** (`pulsecoaching://auth/callback`) — this is not an in-app screen. Supabase appends PKCE/query parameters there; `supabase_flutter` exchanges them for a session on launch. GoRouter then sends the user to **`/login`**:

- **Email confirmed + session created** → login page auto-redirects to home (already signed in).
- **Email confirmed, sign in required** → user lands on login to enter credentials.

Do **not** set the Supabase redirect URL to `/login` or `pulsecoaching://login`. Keep `pulsecoaching://auth/callback` in the dashboard allowlist; only the post-callback navigation is `/login`.

If the link still shows `redirect_to=http://localhost:3000`, update **Site URL** and **Redirect URLs** in the Supabase dashboard as described above. Existing emails keep their old redirect; create a new test user after updating.

Supabase limits how many auth emails can be sent per hour (especially on free projects). If sign-up returns **email rate limit exceeded**, wait about an hour or adjust limits under **Authentication → Rate limits** in the dashboard.

### Deep link opens app then crashes (iOS)

If email confirmation offers to open Pulse but the app crashes with a Firebase `Fatal error: The default FirebaseApp instance must be configured`, that is caused by the bundled `firebase_auth` plugin inspecting every deep link on iOS. The app configures a placeholder Firebase instance at launch when `GoogleService-Info.plist` is absent so Supabase links can be handled safely. Rebuild the iOS app after pulling this fix (`flutter run`, not hot reload).

If the app opens to a missing `auth/callback` route, GoRouter was treating the Supabase redirect URL as an in-app path. The router now redirects that deep link to `/login` while `supabase_flutter` completes the PKCE session in the background.

Tapping an **already used or expired** confirmation link is expected to fail at Supabase. The app catches that error and shows a message on the login screen instead of crashing (e.g. “This confirmation link is invalid or has expired…”).

A **successful** confirmation shows a green success banner on login:

- **Signed in automatically** — “Email confirmed. You're signed in.” Tap **Continue** to go home.
- **Confirm only** — not used; a valid confirmation link signs you in automatically.
- **Invalid or expired link** — error banner with next steps (sign in or sign up again).

## Schema

`public.lessons` stores published coaching videos. IDs are stable slugs (e.g. `morning-mobility`) so they match mock data and saved-lesson references.

`public.user_saved_lessons` stores per-user saves. RLS restricts read/write/update to `auth.uid()`. Guest saves in local storage are promoted to Supabase on sign-in.

Row Level Security on `lessons` allows anonymous read of `published = true` rows.

## Next steps

- Optional Supabase Storage for thumbnails
- Staging/prod Supabase projects per flavor
