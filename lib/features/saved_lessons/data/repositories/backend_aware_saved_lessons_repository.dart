import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/saved_lessons/domain/repositories/saved_lessons_repository.dart';

typedef SavedLessonsUserIdProvider = String? Function();

class BackendAwareSavedLessonsRepository implements SavedLessonsRepository {
  BackendAwareSavedLessonsRepository({
    required BackendType backend,
    required SavedLessonsRepository local,
    required SavedLessonsRepository remote,
    required SavedLessonsUserIdProvider currentUserId,
  }) : _backend = backend,
       _local = local,
       _remote = remote,
       _currentUserId = currentUserId;

  final BackendType _backend;
  final SavedLessonsRepository _local;
  final SavedLessonsRepository _remote;
  final SavedLessonsUserIdProvider _currentUserId;

  SavedLessonsRepository get _active {
    if (_backend == BackendType.supabase && _currentUserId() != null) {
      return _remote;
    }
    return _local;
  }

  @override
  Future<Set<String>> getSavedLessonIds() => _active.getSavedLessonIds();

  @override
  Future<bool> isSaved(String lessonId) => _active.isSaved(lessonId);

  @override
  Future<void> save(String lessonId) => _active.save(lessonId);

  @override
  Future<void> unsave(String lessonId) => _active.unsave(lessonId);
}
