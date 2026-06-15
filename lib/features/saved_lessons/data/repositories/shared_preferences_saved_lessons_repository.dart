import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSavedLessonsRepository
    implements SavedLessonsRepository {
  SharedPreferencesSavedLessonsRepository(this._preferences);

  static const _savedLessonIdsKey = 'saved_lesson_ids';

  final SharedPreferences _preferences;

  @override
  Future<Set<String>> getSavedLessonIds() async {
    return _preferences.getStringList(_savedLessonIdsKey)?.toSet() ?? {};
  }

  @override
  Future<bool> isSaved(String lessonId) async {
    final savedLessonIds = await getSavedLessonIds();
    return savedLessonIds.contains(lessonId);
  }

  @override
  Future<void> save(String lessonId) async {
    final savedLessonIds = await getSavedLessonIds();
    savedLessonIds.add(lessonId);
    await _saveIds(savedLessonIds);
  }

  @override
  Future<void> unsave(String lessonId) async {
    final savedLessonIds = await getSavedLessonIds();
    savedLessonIds.remove(lessonId);
    await _saveIds(savedLessonIds);
  }

  Future<void> _saveIds(Set<String> lessonIds) async {
    final sortedLessonIds = lessonIds.toList()..sort();
    await _preferences.setStringList(_savedLessonIdsKey, sortedLessonIds);
  }

  @override
  Future<void> promoteLocalSavesOnSignIn() async {}
}
