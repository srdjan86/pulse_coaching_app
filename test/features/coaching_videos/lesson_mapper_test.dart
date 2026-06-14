import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/dto/lesson_dto.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/mappers/lesson_mapper.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';

void main() {
  const dto = LessonDto(
    id: 'morning-mobility',
    title: 'Morning Mobility Reset',
    description: 'Start the day with gentle movement.',
    category: 'mobility',
    durationSeconds: 480,
    videoUrl: 'https://example.com/video.mp4',
    thumbnailUrl: 'https://example.com/thumb.jpg',
  );

  test('toEntity maps lesson dto to coaching video', () {
    final video = LessonMapper.toEntity(dto);

    expect(video.id, 'morning-mobility');
    expect(video.title, 'Morning Mobility Reset');
    expect(video.category, CoachingVideoCategory.mobility);
    expect(video.duration, const Duration(minutes: 8));
    expect(video.videoUrl, Uri.parse('https://example.com/video.mp4'));
    expect(video.thumbnailUrl, Uri.parse('https://example.com/thumb.jpg'));
  });

  test('toEntity handles missing thumbnail', () {
    const withoutThumbnail = LessonDto(
      id: 'mindful-breathing',
      title: 'Mindful Breathing Break',
      description: 'A short guided reset.',
      category: 'mindfulness',
      durationSeconds: 300,
      videoUrl: 'https://example.com/video.mp4',
    );

    final video = LessonMapper.toEntity(withoutThumbnail);

    expect(video.thumbnailUrl, isNull);
    expect(video.category, CoachingVideoCategory.mindfulness);
  });

  test('toEntity throws for unknown category', () {
    const invalid = LessonDto(
      id: 'invalid',
      title: 'Invalid',
      description: 'Invalid category.',
      category: 'unknown',
      durationSeconds: 60,
      videoUrl: 'https://example.com/video.mp4',
    );

    expect(() => LessonMapper.toEntity(invalid), throwsFormatException);
  });
}
