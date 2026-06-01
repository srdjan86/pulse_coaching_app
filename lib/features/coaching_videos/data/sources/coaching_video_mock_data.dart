import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';

final coachingVideoMockData = [
  CoachingVideo(
    id: 'morning-mobility',
    title: 'Morning Mobility Reset',
    description:
        'Start the day with gentle movement for hips, shoulders, and spine.',
    category: CoachingVideoCategory.mobility,
    duration: const Duration(minutes: 8),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
    thumbnailUrl: Uri.parse(
      'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    ),
  ),
  CoachingVideo(
    id: 'strength-foundations',
    title: 'Strength Foundations',
    description:
        'A simple full-body strength session focused on controlled reps.',
    category: CoachingVideoCategory.strength,
    duration: const Duration(minutes: 14),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
    thumbnailUrl: Uri.parse(
      'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    ),
  ),
  CoachingVideo(
    id: 'mindful-breathing',
    title: 'Mindful Breathing Break',
    description:
        'A short guided reset to calm your nervous system between sessions.',
    category: CoachingVideoCategory.mindfulness,
    duration: const Duration(minutes: 5),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
    thumbnailUrl: Uri.parse(
      'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    ),
  ),
  CoachingVideo(
    id: 'post-workout-recovery',
    title: 'Post-Workout Recovery',
    description: 'Wind down with low-intensity stretches for better recovery.',
    category: CoachingVideoCategory.recovery,
    duration: const Duration(minutes: 11),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
    thumbnailUrl: Uri.parse(
      'https://assets.mixkit.co/videos/4578/4578-thumb-720-0.jpg',
    ),
  ),
];
