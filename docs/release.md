# Release Process

This document defines the basic release workflow.

## Before release

- Confirm all PRs are merged.
- Confirm CI is passing.
- Run tests locally if needed.
- Update version number in `pubspec.yaml`.
- Prepare release notes (see `docs/RELEASE_NOTES_TEMPLATE.md`).
- Create a TestFlight build.
- Create an Android internal testing build.

## Validation

Before production release, test:

- app startup
- login/onboarding
- main navigation
- critical user flows
- small screen devices
- large screen devices
- Android
- iOS

## Flavor builds

```bash
# Android
flutter build apk --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json

# iOS (after pod install)
flutter build ios --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json
```

## AI role in releases

AI may help with:

- release notes
- QA checklist
- changelog
- test scenarios

AI must not perform final production release without human approval.
