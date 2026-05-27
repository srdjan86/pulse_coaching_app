# Repository Instructions for GitHub Copilot / AI Coding Agents

This is a Flutter mobile app template used for AI-assisted product delivery.

## Technology

- Flutter
- Dart
- iOS
- Android
- Optional Web/Desktop support later

## Architecture

Use feature-first architecture:

```
lib/
  core/
  features/
  app/
```

Each feature should generally contain:

```
features/example/
  data/
  domain/
  presentation/
```

See `docs/architecture.md` for full details.

## Coding rules

- Prefer simple, readable Dart code.
- Do not over-engineer.
- Keep UI, business logic, and data access separated.
- Do not introduce packages unless required.
- If adding a package, explain why.
- Avoid large PRs.
- One task should usually equal one PR.
- Write tests for business logic and important UI behavior.
- Maintain formatting and analyzer cleanliness.
- Do not modify generated files manually.
- Do not remove existing tests to make CI pass.

## Validation

Before completing a task, run:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Pull requests

Every PR should include:

- What changed
- Why it changed
- Screenshots/video if UI changed
- Test coverage
- Known risks
- Manual QA checklist

Follow `.github/pull_request_template.md` and `AGENTS.md`.
