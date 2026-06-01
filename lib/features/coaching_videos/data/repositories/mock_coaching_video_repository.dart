import 'package:pulse_coaching_app/features/coaching_videos/data/sources/coaching_video_mock_data.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';

class MockCoachingVideoRepository implements CoachingVideoRepository {
  @override
  Future<List<CoachingVideo>> getVideos() async {
    return List.unmodifiable(coachingVideoMockData);
  }

  @override
  Future<CoachingVideo?> getVideoById(String id) async {
    for (final video in coachingVideoMockData) {
      if (video.id == id) {
        return video;
      }
    }
    return null;
  }
}
