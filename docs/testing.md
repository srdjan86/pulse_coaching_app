# Testing Strategy

This repository uses automated tests and CI checks to keep AI-assisted development safe.

## Required validation

Before completing any task, run:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Test layout

Mirror feature paths under `test/features/`:

```
test/
  features/
    counter/
    auth/
    home/
  helpers/
    pump_app.dart
```

## Test types

### Unit tests

Use unit tests for:

- business logic
- validation
- repositories
- mappers
- utility classes
- BLoC and ViewModel behavior

### Widget tests

Use widget tests for:

- important screens
- form validation
- empty states
- loading states
- error states
- important user interactions

### Integration tests

Use integration tests later for critical user flows such as:

- onboarding
- login
- subscription purchase
- checkout
- content playback

Add under `integration_test/` when needed.

## Rules

- Do not delete tests to make CI pass.
- If a test becomes invalid, update it with an explanation.
- New important behavior should include test coverage where practical.
- Tests use the **mock** backend — no Firebase/Supabase credentials required.

## CI

GitHub Actions (`.github/workflows/flutter_ci.yml`) runs:

1. Format check (`lib test` only)
2. `flutter analyze --fatal-infos`
3. `flutter test --coverage`
4. Android dev-flavor APK smoke build
