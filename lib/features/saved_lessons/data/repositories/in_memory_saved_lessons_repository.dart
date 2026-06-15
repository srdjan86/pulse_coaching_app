import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';

class InMemorySavedLessonsRepository implements SavedLessonsRepository {
  InMemorySavedLessonsRepository({Set<String>? initialSavedLessonIds})
    : _savedLessonIds = {...?initialSavedLessonIds};

  final Set<String> _savedLessonIds;

  @override
  Future<Set<String>> getSavedLessonIds() async {
    return {..._savedLessonIds};
  }

  @override
  Future<bool> isSaved(String lessonId) async {
    return _savedLessonIds.contains(lessonId);
  }

  @override
  Future<void> save(String lessonId) async {
    _savedLessonIds.add(lessonId);
  }

  @override
  Future<void> unsave(String lessonId) async {
    _savedLessonIds.remove(lessonId);
  }

  @override
  Future<void> promoteLocalSavesOnSignIn() async {}
}
