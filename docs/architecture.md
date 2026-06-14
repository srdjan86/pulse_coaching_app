# Architecture

This project uses a feature-first Flutter architecture.

## Folder structure

```
lib/
  app/
    di/
    router/
  core/
    config/
    errors/
    theme/
  features/
    example_feature/
      data/
      domain/
      presentation/
  l10n/
```

Optional shared code can live under `lib/core/` or a future `lib/shared/` folder.

## Layer responsibilities

### Presentation

Contains screens, widgets, view models, BLoCs, Cubits, or controllers.

Presentation should not directly perform network calls or database access.

### Domain

Contains business entities and repository interfaces.

For simple features, domain can remain lightweight.

### Data

Contains repositories, DTOs, API clients, local storage, and mappers.

## State management

Use the simplest suitable approach for each feature.

| Feature | Pattern | Location |
|---------|---------|----------|
| Counter | BLoC | `features/counter/` |
| Auth | MVVM (`ChangeNotifier` + `provider`) | `features/auth/` |

For new complex flows, prefer BLoC/Cubit or MVVM-style separation.

## Routing

GoRouter is configured in `lib/app/router/app_router.dart`.

## Dependency injection

GetIt registrations live in `lib/app/di/service_locator.dart`.

## Backends

Auth supports `mock` (default), `firebase`, and `supabase` via `AppConfig` / dart-define.

The lesson catalog uses Supabase when `BACKEND=supabase`; see `docs/supabase.md`.

## Flavors

`dev`, `staging`, and `prod` entry points with matching Android/iOS flavor configuration.

## Testing

Business logic should be unit tested.

Important UI behavior should be widget tested.

Critical user flows may be covered by integration tests later.

See `docs/testing.md`.
