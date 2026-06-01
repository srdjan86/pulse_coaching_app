# Release Process

This document defines the release workflow for the Pulse coaching app.

## Automated release (standard path)

Releases are cut via the **Release** GitHub Actions workflow. No manual version bumping or changelog editing is required.

### Steps

1. Ensure all feature PRs are merged into `develop`.
2. Open a PR from `develop` → `main` and merge it (human review required).
3. Go to **Actions → Release → Run workflow** on the `main` branch.
4. Enter:
   - **version** — semantic version without `v`, e.g. `0.2.0`
   - **build_number** — positive integer, e.g. `2`
5. The workflow will:
   - Validate inputs and check the tag doesn't already exist
   - Run `dart format`, `flutter analyze --fatal-infos`, and `flutter test`
   - Bump the version in `pubspec.yaml`
   - Generate release notes via the Cursor SDK agent (reads git log since last tag)
   - Update `CHANGELOG.md` with the new entry
   - Commit the version bump and changelog to `main`
   - Create and push the git tag `vX.Y.Z`
   - Publish a GitHub Release

### Requirements

- `CURSOR_API_KEY` must be set in repository secrets (Actions → Secrets).
- The `main` branch must be up to date with `develop`.

---

## Before each release — checklist

- [ ] All PRs for this milestone merged and CI green on `develop`
- [ ] `develop` → `main` PR reviewed and merged
- [ ] `CURSOR_API_KEY` secret present in GitHub Actions
- [ ] Version and build number agreed (follow semver: patch = bugfix, minor = new feature, major = breaking change)

## Validation (manual QA)

Before triggering the release workflow, verify on a physical device or simulator:

- App startup and onboarding flow
- Login screen and error states
- Home screen navigation
- Theme switching (light / dark / system)
- Small screen and large screen

## Flavor builds (manual, when needed)

```bash
# Android
flutter build apk --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json

# iOS (after pod install in ios/)
flutter build ios --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json
```

## AI role in releases

The Cursor SDK release notes agent assists with:

- Generating grouped, user-facing release notes from the git log
- Updating `CHANGELOG.md`

The agent does **not**:

- Make the final decision to release
- Push to stores
- Bypass the `develop` → `main` PR review

## Partial failure recovery

If the release workflow fails mid-run (e.g. after the version commit but before the tag):

1. Check the Actions log to identify the last successful step.
2. If a tag was not created, re-run the workflow — it will fail fast on the version conflict step.
3. If a tag was created but the GitHub Release was not, create the release manually:
   ```bash
   gh release create vX.Y.Z --title "vX.Y.Z" --notes-file /tmp/release_notes.md
   ```
4. If the version was bumped on `main` but the tag was not created, delete the commit and re-run:
   ```bash
   git revert HEAD --no-edit && git push
   ```
