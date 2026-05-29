# Pulse theme tokens

## Usage

- Prefer `Theme.of(context).colorScheme` for Material widgets (`FilledButton`, `TextField`, `Card`, etc.).
- Use `AppColors.of(context)` when you need a named brand token explicitly.

## Tokens (`AppColors.light`)

| Token | Role |
|-------|------|
| `primary` | Brand CTA, key accents |
| `onPrimary` | Content on primary |
| `surface` | Scaffold / screen background |
| `onSurface` | Primary text |
| `error` | Validation and errors |
| `onError` | Content on error |
| `surfaceContainer` | Cards and filled inputs |

Flavor (`dev` / `staging` / `prod`) only adjusts **secondary** accent via `AppTheme.light(flavor: ...)`.

Dark mode is not implemented yet.
