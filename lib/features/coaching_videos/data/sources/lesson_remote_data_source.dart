import 'package:pulse_coaching_app/features/coaching_videos/data/dto/lesson_dto.dart';

abstract class LessonRemoteDataSource {
  Future<List<LessonDto>> fetchPublishedLessons();

  Future<LessonDto?> fetchLessonById(String id);
}
