import 'package:pulse_coaching_app/features/coaching_videos/data/dto/lesson_dto.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';

class LessonMapper {
  const LessonMapper._();

  static CoachingVideo toEntity(LessonDto dto) {
    return CoachingVideo(
      id: dto.id,
      title: dto.title,
      description: dto.description,
      category: _parseCategory(dto.category),
      duration: Duration(seconds: dto.durationSeconds),
      videoUrl: Uri.parse(dto.videoUrl),
      thumbnailUrl: dto.thumbnailUrl == null
          ? null
          : Uri.parse(dto.thumbnailUrl!),
    );
  }

  static CoachingVideoCategory _parseCategory(String value) {
    return switch (value) {
      'mindfulness' => CoachingVideoCategory.mindfulness,
      'strength' => CoachingVideoCategory.strength,
      'mobility' => CoachingVideoCategory.mobility,
      'recovery' => CoachingVideoCategory.recovery,
      _ => throw FormatException('Unknown lesson category: $value'),
    };
  }
}
