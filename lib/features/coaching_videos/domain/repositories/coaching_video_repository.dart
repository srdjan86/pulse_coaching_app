import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';

abstract class CoachingVideoRepository {
  Future<List<CoachingVideo>> getVideos();

  Future<CoachingVideo?> getVideoById(String id);
}
