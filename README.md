# Pulse Coaching App

A minimal **coaching & wellness MVP** built from the [AI Flutter Delivery Template](https://github.com/srdjan86/ai_flutter_delivery_template).

This repo is the **product** — features and backlog live here; work is tracked in **GitHub Issues**. The template stays generic; Pulse is where we ship.

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

## Backlog (GitHub Issues)

| Issue | Title | Status |
|-------|--------|--------|
| [#1](https://github.com/srdjan86/pulse_coaching_app/issues/1) | Onboarding screen | Open |
| [#2](https://github.com/srdjan86/pulse_coaching_app/issues/2) | App theme & design tokens | Open |
| [#3](https://github.com/srdjan86/pulse_coaching_app/issues/3) | Login form UI | Open |
| [#4](https://github.com/srdjan86/pulse_coaching_app/issues/4) | Saved lessons (local) | Open |
| [#5](https://github.com/srdjan86/pulse_coaching_app/issues/5) | Lesson feed (mock data) | Open |

[View all issues](https://github.com/srdjan86/pulse_coaching_app/issues). Create new work there before starting AI implementation.

## Workflow

See `docs/ai-workflow.md` and `AGENTS.md`.

## Origin

Created from `srdjan86/ai_flutter_delivery_template` — do not merge product-specific changes back into the template unless they improve the factory itself.
