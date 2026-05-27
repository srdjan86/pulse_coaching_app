# Ticket 001: Onboarding Screen

## Problem

New users need a welcoming entry point that explains Pulse and captures email before entering the app.

## User story

As a new user, I want to see a clean onboarding screen with my email, so that I can start using Pulse.

## Scope

- [ ] Create `features/onboarding/` with presentation layer
- [ ] Title, subtitle, email field, primary CTA
- [ ] Email validation (format only)
- [ ] Loading state on submit
- [ ] Success placeholder / navigate to home
- [ ] Localization strings (en + sr)
- [ ] Route from app shell (first launch or `/onboarding`)

## Out of scope

- [ ] Real backend / Firebase auth
- [ ] Social login
- [ ] Persistent “has seen onboarding” storage (optional follow-up)

## Acceptance criteria

- [ ] Invalid email shows validation message
- [ ] Valid email triggers loading then success/navigation
- [ ] Works on small and large screens
- [ ] Widget tests for initial, invalid, valid submit
- [ ] CI passes

## Technical notes

- Follow BLoC or MVVM consistent with existing features
- Register route in `lib/app/router/app_router.dart`
- Mock submit delay ~300ms

## Test plan

- [ ] Widget: initial render
- [ ] Widget: invalid email
- [ ] Widget: valid submit shows loading
