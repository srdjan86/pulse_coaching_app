-- Lessons catalog for Pulse coaching videos.
-- IDs use stable slugs to match mock data and saved-lesson references.

create table public.lessons (
  id text primary key,
  title text not null,
  description text not null,
  category text not null check (
    category in ('mindfulness', 'strength', 'mobility', 'recovery')
  ),
  duration_seconds integer not null check (duration_seconds > 0),
  video_url text not null,
  thumbnail_url text,
  published boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

alter table public.lessons enable row level security;

create policy "Published lessons are readable by everyone"
  on public.lessons
  for select
  using (published = true);

insert into public.lessons (
  id,
  title,
  description,
  category,
  duration_seconds,
  video_url,
  thumbnail_url,
  sort_order
) values
  (
    'morning-mobility',
    'Morning Mobility Reset',
    'Start the day with gentle movement for hips, shoulders, and spine.',
    'mobility',
    480,
    'https://assets.mixkit.co/videos/4578/4578-720.mp4',
    'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    1
  ),
  (
    'strength-foundations',
    'Strength Foundations',
    'A simple full-body strength session focused on controlled reps.',
    'strength',
    840,
    'https://assets.mixkit.co/videos/4578/4578-720.mp4',
    'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    2
  ),
  (
    'mindful-breathing',
    'Mindful Breathing Break',
    'A short guided reset to calm your nervous system between sessions.',
    'mindfulness',
    300,
    'https://assets.mixkit.co/videos/4578/4578-720.mp4',
    'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    3
  ),
  (
    'post-workout-recovery',
    'Post-Workout Recovery',
    'Wind down with low-intensity stretches for better recovery.',
    'recovery',
    660,
    'https://assets.mixkit.co/videos/4578/4578-720.mp4',
    'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    4
  ),
  (
    'evening-stretch',
    'Evening Stretch Downshift',
    'Ease into rest with slow stretches for the neck, back, and hips.',
    'recovery',
    540,
    'https://assets.mixkit.co/videos/4578/4578-720.mp4',
    'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    5
  );
