import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/dto/lesson_dto.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/repositories/supabase_coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/sources/lesson_remote_data_source.dart';

class _FakeLessonRemoteDataSource implements LessonRemoteDataSource {
  _FakeLessonRemoteDataSource({required this.lessons});

  final List<LessonDto> lessons;

  @override
  Future<List<LessonDto>> fetchPublishedLessons() async => lessons;

  @override
  Future<LessonDto?> fetchLessonById(String id) async {
    for (final lesson in lessons) {
      if (lesson.id == id) {
        return lesson;
      }
    }
    return null;
  }
}

void main() {
  const lessons = [
    LessonDto(
      id: 'morning-mobility',
      title: 'Morning Mobility Reset',
      description: 'Start the day with gentle movement.',
      category: 'mobility',
      durationSeconds: 480,
      videoUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://example.com/thumb.jpg',
    ),
    LessonDto(
      id: 'mindful-breathing',
      title: 'Mindful Breathing Break',
      description: 'A short guided reset.',
      category: 'mindfulness',
      durationSeconds: 300,
      videoUrl: 'https://example.com/video.mp4',
    ),
  ];

  late SupabaseCoachingVideoRepository repository;

  setUp(() {
    repository = SupabaseCoachingVideoRepository(
      _FakeLessonRemoteDataSource(lessons: lessons),
    );
  });

  test('getVideos returns mapped coaching videos', () async {
    final videos = await repository.getVideos();

    expect(videos, hasLength(2));
    expect(videos.first.id, 'morning-mobility');
    expect(videos.first.title, 'Morning Mobility Reset');
  });

  test('getVideoById returns matching coaching video', () async {
    final video = await repository.getVideoById('mindful-breathing');

    expect(video, isNotNull);
    expect(video?.id, 'mindful-breathing');
    expect(video?.thumbnailUrl, isNull);
  });

  test('getVideoById returns null for unknown id', () async {
    final video = await repository.getVideoById('unknown');

    expect(video, isNull);
  });
}
