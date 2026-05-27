# Ticket 004: Saved Lessons (Local)

## Problem

Users should save favorite coaching lessons for offline access.

## Scope

- [ ] `Lesson` entity + `SavedLessonsRepository` (local in-memory or shared_preferences)
- [ ] Save / unsave from lesson detail or list
- [ ] Saved list screen

## Out of scope

- [ ] Cloud sync
- [ ] Backend API

## Acceptance criteria

- [ ] Save persists for app session (or disk if using preferences)
- [ ] Unit tests for repository
- [ ] Widget test for saved list empty/filled
- [ ] CI passes
