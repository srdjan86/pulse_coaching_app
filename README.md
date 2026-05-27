# Pulse Coaching App

A minimal **coaching & wellness MVP** built from the [AI Flutter Delivery Template](https://github.com/srdjan86/ai_flutter_delivery_template).

This repo is the **product** — tickets, features, and case-study work live here. The template stays generic; Pulse is where we ship.

## Concept

Pulse helps users discover coaching content, track progress, and save favorite lessons — starting with mock data and growing through AI-assisted delivery (ticket → plan → PR → CI).

## Stack

Inherited from the template: Flutter, BLoC, MVVM, flavors, localization, GitHub Actions, `AGENTS.md`.

## Run locally

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/dev.json
```

## Validation

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Ticket backlog

| # | Ticket | Status |
|---|--------|--------|
| 001 | [Onboarding screen](docs/tickets/001_onboarding_screen.md) | Ready |
| 002 | [App theme & design tokens](docs/tickets/002_app_theme.md) | Planned |
| 003 | [Login form UI](docs/tickets/003_login_form_ui.md) | Planned |
| 004 | [Saved lessons (local)](docs/tickets/004_saved_lessons_local.md) | Planned |
| 005 | [Lesson feed (mock data)](docs/tickets/005_lesson_feed_mock.md) | Planned |

Create a GitHub issue from each ticket before starting AI implementation.

## Workflow

See `docs/ai-workflow.md` and `AGENTS.md`.

## Origin

Created from `srdjan86/ai_flutter_delivery_template` — do not merge product-specific changes back into the template unless they improve the factory itself.
