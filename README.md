# Pulse Coaching App

A **coaching & wellness MVP** and **portfolio proof-of-work** for senior Flutter delivery with AI-assisted workflows — built from the [AI Flutter Delivery Template](https://github.com/srdjan86/ai_flutter_delivery_template).

Pulse is the product repo: features, backlog, and shipped PRs live here.

## At a glance

| Area | Highlights |
|------|------------|
| **Architecture** | Feature-first (`domain` / `data` / `presentation`), repository pattern, GetIt DI, GoRouter |
| **State** | BLoC (counter), MVVM + `provider` (auth, home, lessons) |
| **Backends** | `mock` (CI default), `firebase`, **Supabase** (lessons, auth, saved-lessons sync) |
| **Flavors** | `dev`, `staging`, `prod` with dart-define config |
| **Quality** | 110+ unit/widget/integration tests, format + analyze + test in CI |
| **Delivery** | GitHub Issues → plan → PR → CI → review ([workflow docs](docs/ai-workflow.md)) |

## Shipped highlights

| PR | What it demonstrates |
|----|----------------------|
| [#23](https://github.com/srdjan86/pulse_coaching_app/pull/23) | Figma design system applied to Flutter UI |
| [#24](https://github.com/srdjan86/pulse_coaching_app/pull/24) | Saved lessons + expanded lesson feed |
| [#25](https://github.com/srdjan86/pulse_coaching_app/pull/25) | AI-assisted delivery case study |
| [#26](https://github.com/srdjan86/pulse_coaching_app/pull/26) | Supabase lesson catalog backend |
| [#28](https://github.com/srdjan86/pulse_coaching_app/pull/28) | Supabase auth, saved-lessons sync, email deep links |

**Case study:** [`docs/ai-assisted-delivery.md`](docs/ai-assisted-delivery.md) — client-facing narrative of ticket → plan → code → tests → PR → CI.

**Backend setup:** [`docs/supabase.md`](docs/supabase.md) — migrations, credentials, staging run.

## Run locally

**Dev (mock backend, no credentials):**

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run --flavor dev -t lib/main_dev.dart --dart-define-from-file=config/dev.json
```

**Staging (Supabase)** — add your project URL and publishable key locally in `config/staging.json` (never commit real keys):

```bash
flutter run --flavor staging -t lib/main_staging.dart \
  --dart-define-from-file=config/staging.json
```

## Validation

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Stack

Flutter · Dart 3.11+ · BLoC · MVVM · GoRouter · GetIt · localization (en, sr) · GitHub Actions · `AGENTS.md`

## Backlog

| Issue | Title | Status |
|-------|--------|--------|
| [#1](https://github.com/srdjan86/pulse_coaching_app/issues/1) | Onboarding screen | Closed |
| [#2](https://github.com/srdjan86/pulse_coaching_app/issues/2) | App theme & design tokens | Closed |
| [#3](https://github.com/srdjan86/pulse_coaching_app/issues/3) | Login form UI | Closed |
| [#4](https://github.com/srdjan86/pulse_coaching_app/issues/4) | Saved lessons (local) | Closed |
| [#5](https://github.com/srdjan86/pulse_coaching_app/issues/5) | Lesson feed (mock data) | Closed |
| [#20](https://github.com/srdjan86/pulse_coaching_app/issues/20) | Apply Figma design to Flutter UI | Closed |

[View all issues](https://github.com/srdjan86/pulse_coaching_app/issues)

## Workflow

See [`docs/ai-assisted-delivery.md`](docs/ai-assisted-delivery.md), [`docs/ai-workflow.md`](docs/ai-workflow.md), and [`AGENTS.md`](AGENTS.md).

## Origin

Created from `srdjan86/ai_flutter_delivery_template` — product-specific changes stay in this repo unless they improve the template factory itself.
