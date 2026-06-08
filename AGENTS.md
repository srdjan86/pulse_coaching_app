# AI Agent Instructions

This repository is an AI-assisted Flutter delivery template.

The goal is to simulate a professional mobile product workflow:

ticket → implementation plan → code → tests → pull request → review → release

## Role of the AI agent

AI may help with:

- feature planning
- implementation
- refactoring
- test generation
- documentation
- pull request descriptions
- QA checklists

AI must not:

- merge pull requests
- introduce new dependencies without approval
- remove tests to make CI pass
- change app architecture without explaining why
- modify generated files manually
- make production/security/payment changes without explicit review

## Project standards

- Use Flutter and Dart.
- Prefer feature-first architecture.
- Keep widgets small and composable.
- Business logic should not live directly inside UI widgets.
- Use repository/service layers for external data sources.
- Use BLoC/Cubit or MVVM-style separation for complex state when needed.
- All user-facing strings should be localization-ready.
- New functionality should include tests where practical.
- Keep PRs small and focused.
- One task should usually equal one PR.

## Before coding

For every ticket, first produce an implementation plan that includes:

1. Summary of the requested change
2. Files likely to be changed
3. Architecture impact
4. State management impact
5. Test plan
6. Risks / edge cases
7. Questions or assumptions

Do not start coding before the plan is reviewed.

## Validation commands

Before finalizing work, run:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

If UI changed, include screenshots or screen recording in the PR.

## Commit and PR approval

After making code changes, the agent must stop after validation and summarize:

- files changed
- tests / commands run
- known risks or follow-ups

The agent must not commit, push, or create a pull request until the user explicitly approves that action.

## Dart style notes

For unused callback parameters, use Dart wildcard parameters:

```dart
separatorBuilder: (_, _) => const SizedBox(height: 12)
```

Do not replace unused callback parameters with named variables such as `(context, index)` unless those values are actually used. Avoid `__`, `___`, or similar placeholder names; use repeated `_` instead.

## Project overview

- **Stack**: Flutter (Dart 3.11+), BLoC, MVVM (`provider`), GoRouter, GetIt
- **Backends**: `mock` (default), `firebase`, `supabase` — selected via dart-define
- **Flavors**: `dev`, `staging`, `prod`
- **Default path**: mock backend, no credentials required — safe for CI and agent runs

## Key commands

```bash
flutter pub get
flutter gen-l10n          # after editing lib/l10n/*.arb
flutter analyze
dart format lib test
flutter test

flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/dev.json
```

## Project structure

```
lib/
├── app/                 # App shell, DI, routing
├── core/                # Config, theme, errors
├── features/            # Feature-first modules (domain/data/presentation)
├── l10n/
├── main.dart
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
config/                  # Per-flavor dart-define JSON
test/                    # Mirrors lib/features/
docs/                    # Architecture, workflow, testing, release
```

## Architecture rules

1. **Feature-first layout** — each feature owns `domain/`, `data/`, `presentation/`.
2. **BLoC for interactive state** — see `features/counter/`.
3. **MVVM for simpler flows** — see `features/auth/`.
4. **Repository pattern** — interfaces in `domain/repositories/`, implementations in `data/repositories/`.
5. **DI via GetIt** — register in `lib/app/di/service_locator.dart`.
6. **Routing via GoRouter** — add routes in `lib/app/router/app_router.dart`.
7. **Localization** — add strings to `lib/l10n/app_en.arb`, run `flutter gen-l10n`.

See also: `docs/architecture.md`, `docs/ai-workflow.md`, `docs/testing.md`.

## Boundaries

### Allowed without asking

- Read files, run analyze/test/format
- Add tests and feature code within existing architecture
- Update localization ARB files

### Ask first

- Add or remove dependencies
- Change CI workflow or flavor matrix
- Delete files or change public API surface broadly

### Never

- Commit secrets, `.env`, Firebase/Supabase credentials
- Force-push to `main`
- Disable CI checks to merge failing code

## Non-obvious notes

- Android **requires** `--flavor` when product flavors are defined.
- iOS **requires** Xcode schemes `dev`, `staging`, `prod`. Run `pod install` in `ios/` after `flutter pub get`.
- Format only `lib` and `test` — do not run `dart format .` (avoids `build/` symlink issues).
