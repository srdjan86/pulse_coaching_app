import '../../helpers/fake_auth_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/in_memory_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/view_models/saved_lessons_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SavedLessonsViewModel', () {
    test('load returns only saved lessons', () async {
      final viewModel = SavedLessonsViewModel(
        coachingVideoRepository: _FakeCoachingVideoRepository(videos: _videos),
        savedLessonsRepository: InMemorySavedLessonsRepository(
          initialSavedLessonIds: {'morning-mobility'},
        ),
        authRepository: FakeAuthRepository(),
      );
      addTearDown(viewModel.dispose);

      await viewModel.load();

      expect(viewModel.isLoaded, isTrue);
      expect(viewModel.hasError, isFalse);
      expect(viewModel.savedVideos, [_videos.first]);
    });

    test('load captures repository errors', () async {
      final viewModel = SavedLessonsViewModel(
        coachingVideoRepository: _FakeCoachingVideoRepository(
          throwsOnLoad: true,
        ),
        savedLessonsRepository: InMemorySavedLessonsRepository(
          initialSavedLessonIds: {'morning-mobility'},
        ),
        authRepository: FakeAuthRepository(),
      );
      addTearDown(viewModel.dispose);

      await viewModel.load();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.hasError, isTrue);
    });
  });
}

final _videos = [
  CoachingVideo(
    id: 'morning-mobility',
    title: 'Morning Mobility Reset',
    description: 'Start the day with gentle movement.',
    category: CoachingVideoCategory.mobility,
    duration: const Duration(minutes: 8),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
  ),
  CoachingVideo(
    id: 'strength-foundations',
    title: 'Strength Foundations',
    description: 'Controlled full-body strength.',
    category: CoachingVideoCategory.strength,
    duration: const Duration(minutes: 14),
    videoUrl: Uri.parse('https://assets.mixkit.co/videos/4578/4578-720.mp4'),
  ),
];

class _FakeCoachingVideoRepository implements CoachingVideoRepository {
  _FakeCoachingVideoRepository({
    this.videos = const [],
    this.throwsOnLoad = false,
  });

  final List<CoachingVideo> videos;
  final bool throwsOnLoad;

  @override
  Future<List<CoachingVideo>> getVideos() async {
    if (throwsOnLoad) {
      throw StateError('failed');
    }
    return videos;
  }

  @override
  Future<CoachingVideo?> getVideoById(String id) async {
    for (final video in videos) {
      if (video.id == id) {
        return video;
      }
    }
    return null;
  }
}
