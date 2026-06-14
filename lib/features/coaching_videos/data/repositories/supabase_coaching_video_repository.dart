import 'package:pulse_coaching_app/features/coaching_videos/data/mappers/lesson_mapper.dart';
import 'package:pulse_coaching_app/features/coaching_videos/data/sources/lesson_remote_data_source.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/repositories/coaching_video_repository.dart';

class SupabaseCoachingVideoRepository implements CoachingVideoRepository {
  SupabaseCoachingVideoRepository(this._remoteDataSource);

  final LessonRemoteDataSource _remoteDataSource;

  @override
  Future<List<CoachingVideo>> getVideos() async {
    final lessons = await _remoteDataSource.fetchPublishedLessons();
    return lessons.map(LessonMapper.toEntity).toList();
  }

  @override
  Future<CoachingVideo?> getVideoById(String id) async {
    final lesson = await _remoteDataSource.fetchLessonById(id);
    if (lesson == null) {
      return null;
    }

    return LessonMapper.toEntity(lesson);
  }
}
