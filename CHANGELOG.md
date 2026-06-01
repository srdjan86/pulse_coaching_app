# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [0.1.0] – 2026-06-01

First milestone release of the Pulse coaching app template.
Establishes the full AI-assisted delivery workflow and core app scaffolding.

### Added

- **Onboarding screen** — email input with validation, loading state, and navigation to home on submit
- **Onboarding persistence** — completed state saved locally via `shared_preferences`; returning users bypass onboarding on relaunch
- **Login screen** — email and password fields with non-empty validation, loading spinner, and error display; wired to mock auth backend
- **App theme and design tokens** — `AppColors` theme extension with light and dark palettes; `AppTheme.light` / `AppTheme.dark` factory methods; flavor accent colours for `dev`, `staging`, `prod`
- **Theme settings** — user-selectable light, dark, or system theme mode; preference persisted locally
- **Settings screen** — segmented button for theme mode selection, accessible from the home screen app bar
- **Localization** — all user-facing strings in `app_en.arb` and `app_sr.arb`; `flutter gen-l10n` integrated into workflow
- **PR Review Agent** — GitHub Actions workflow using Cursor SDK; posts a structured ✅/⚠️/❌ verdict on every PR against `develop` or `main`
- **Issue Planning Agent** — triggered by the `ready-for-planning` label; posts an 8-section implementation plan as an issue comment
- **Release workflow** — manual `workflow_dispatch` to bump version, generate release notes via Cursor SDK, tag, and publish a GitHub Release
- **FVM version pin** — Flutter `3.44.0` pinned via `.fvm/fvm_config.json`
- **Branch protection** — `develop` requires PRs; `main` requires PRs and a review

### Architecture

- Feature-first layout (`features/onboarding/`, `features/auth/`, `features/settings/`)
- MVVM with `ChangeNotifier` for onboarding, auth, and theme settings
- Repository pattern with in-memory implementations for testing
- Dependency injection via `GetIt`; `SharedPreferences` injected for testability
- Routing via `GoRouter` with redirect guard for onboarding state
