import 'package:pulse_coaching_app/features/coaching_videos/data/sources/coaching_video_mock_data.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_library_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoachingVideoLibraryViewModel', () {
    test('load populates videos', () async {
      final viewModel = CoachingVideoLibraryViewModel(
        _FakeCoachingVideoRepository(videos: coachingVideoMockData),
      );

      await viewModel.load();

      expect(viewModel.isLoaded, isTrue);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.videos, coachingVideoMockData);
      expect(viewModel.errorMessage, isNull);
    });

    test('load captures repository errors', () async {
      final viewModel = CoachingVideoLibraryViewModel(
        _FakeCoachingVideoRepository(throwsOnLoad: true),
      );

      await viewModel.load();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNotNull);
    });
  });

  group('CoachingVideoDetailViewModel', () {
    test('load populates matching video', () async {
      final viewModel = CoachingVideoDetailViewModel(
        _FakeCoachingVideoRepository(videos: coachingVideoMockData),
      );

      await viewModel.load('morning-mobility');

      expect(viewModel.isLoaded, isTrue);
      expect(viewModel.video?.id, 'morning-mobility');
      expect(viewModel.errorMessage, isNull);
    });

    test('load keeps video null when not found', () async {
      final viewModel = CoachingVideoDetailViewModel(
        _FakeCoachingVideoRepository(videos: coachingVideoMockData),
      );

      await viewModel.load('missing');

      expect(viewModel.isLoaded, isTrue);
      expect(viewModel.video, isNull);
    });
  });
}

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
