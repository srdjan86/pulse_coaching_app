import 'package:pulse_coaching_app/features/saved_lessons/data/sources/saved_lesson_remote_data_source.dart';
import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';

class SupabaseSavedLessonsRepository implements SavedLessonsRepository {
  SupabaseSavedLessonsRepository(
    this._remoteDataSource, {
    String? Function()? userIdProvider,
  }) : _userIdProvider = userIdProvider ?? (() => null);

  final SavedLessonRemoteDataSource _remoteDataSource;
  final String? Function() _userIdProvider;

  String _requireUserId() {
    final userId = _userIdProvider();
    if (userId == null) {
      throw StateError('Saved lessons require a signed-in user.');
    }
    return userId;
  }

  @override
  Future<Set<String>> getSavedLessonIds() async {
    final userId = _userIdProvider();
    if (userId == null) {
      return {};
    }

    return _remoteDataSource.fetchSavedLessonIds(userId);
  }

  @override
  Future<bool> isSaved(String lessonId) async {
    final savedLessonIds = await getSavedLessonIds();
    return savedLessonIds.contains(lessonId);
  }

  @override
  Future<void> save(String lessonId) async {
    await _remoteDataSource.save(_requireUserId(), lessonId);
  }

  @override
  Future<void> unsave(String lessonId) async {
    await _remoteDataSource.unsave(_requireUserId(), lessonId);
  }

  @override
  Future<void> promoteLocalSavesOnSignIn() async {}
}
