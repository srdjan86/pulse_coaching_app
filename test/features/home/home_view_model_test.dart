import 'package:pulse_coaching_app/features/coaching_videos/data/sources/coaching_video_mock_data.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';
import 'package:pulse_coaching_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('load exposes session count and continue videos', () async {
    final viewModel = HomeViewModel(
      _FakeCoachingVideoRepository(videos: coachingVideoMockData),
    );

    await viewModel.load();

    expect(viewModel.isLoaded, isTrue);
    expect(viewModel.hasError, isFalse);
    expect(viewModel.sessionCount, coachingVideoMockData.length);
    expect(viewModel.continueVideos, coachingVideoMockData.take(2));
  });

  test('load hides continue section data on repository failure', () async {
    final viewModel = HomeViewModel(
      _FakeCoachingVideoRepository(throwsOnLoad: true),
    );

    await viewModel.load();

    expect(viewModel.isLoaded, isTrue);
    expect(viewModel.hasError, isTrue);
    expect(viewModel.sessionCount, 0);
    expect(viewModel.continueVideos, isEmpty);
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
