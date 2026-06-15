import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coaching_app/core/config/backend_type.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/backend_aware_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/in_memory_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/supabase_saved_lessons_repository.dart';
import 'package:pulse_coaching_app/features/saved_lessons/data/sources/saved_lesson_remote_data_source.dart';

class _FakeSavedLessonRemoteDataSource implements SavedLessonRemoteDataSource {
  _FakeSavedLessonRemoteDataSource({Map<String, Set<String>>? savedByUser})
    : _savedByUser = savedByUser ?? {};

  final Map<String, Set<String>> _savedByUser;

  @override
  Future<Set<String>> fetchSavedLessonIds(String userId) async {
    return _savedByUser[userId] ?? {};
  }

  @override
  Future<void> save(String userId, String lessonId) async {
    _savedByUser.putIfAbsent(userId, () => {}).add(lessonId);
  }

  @override
  Future<void> unsave(String userId, String lessonId) async {
    _savedByUser[userId]?.remove(lessonId);
  }
}

void main() {
  group('SupabaseSavedLessonsRepository', () {
    late _FakeSavedLessonRemoteDataSource remoteDataSource;
    late SupabaseSavedLessonsRepository repository;

    setUp(() {
      remoteDataSource = _FakeSavedLessonRemoteDataSource();
      repository = SupabaseSavedLessonsRepository(
        remoteDataSource,
        userIdProvider: () => 'user-1',
      );
    });

    test('returns empty set when user id is missing', () async {
      final guestRepository = SupabaseSavedLessonsRepository(
        remoteDataSource,
        userIdProvider: () => null,
      );

      expect(await guestRepository.getSavedLessonIds(), isEmpty);
    });

    test('saves and removes lessons for signed-in user', () async {
      await repository.save('morning-mobility');

      expect(await repository.isSaved('morning-mobility'), isTrue);
      expect(await repository.getSavedLessonIds(), {'morning-mobility'});

      await repository.unsave('morning-mobility');

      expect(await repository.isSaved('morning-mobility'), isFalse);
    });

    test('save throws when user is not signed in', () async {
      final guestRepository = SupabaseSavedLessonsRepository(
        remoteDataSource,
        userIdProvider: () => null,
      );

      expect(() => guestRepository.save('morning-mobility'), throwsStateError);
    });
  });

  group('BackendAwareSavedLessonsRepository', () {
    test('uses remote repository when supabase user is signed in', () async {
      final local = InMemorySavedLessonsRepository();
      final remote = SupabaseSavedLessonsRepository(
        _FakeSavedLessonRemoteDataSource(),
        userIdProvider: () => 'user-1',
      );
      final repository = BackendAwareSavedLessonsRepository(
        backend: BackendType.supabase,
        local: local,
        remote: remote,
        currentUserId: () => 'user-1',
      );

      await repository.save('mindful-breathing');

      expect(await repository.isSaved('mindful-breathing'), isTrue);
      expect(await local.isSaved('mindful-breathing'), isFalse);
    });

    test('uses local repository for guests on supabase backend', () async {
      final local = InMemorySavedLessonsRepository();
      final remote = SupabaseSavedLessonsRepository(
        _FakeSavedLessonRemoteDataSource(),
        userIdProvider: () => 'user-1',
      );
      final repository = BackendAwareSavedLessonsRepository(
        backend: BackendType.supabase,
        local: local,
        remote: remote,
        currentUserId: () => null,
      );

      await repository.save('mindful-breathing');

      expect(await local.isSaved('mindful-breathing'), isTrue);
      expect(await remote.getSavedLessonIds(), isEmpty);
    });

    test('promotes local saves to remote on sign in', () async {
      final local = InMemorySavedLessonsRepository(
        initialSavedLessonIds: {'morning-mobility'},
      );
      final remoteDataSource = _FakeSavedLessonRemoteDataSource();
      final remote = SupabaseSavedLessonsRepository(
        remoteDataSource,
        userIdProvider: () => 'user-1',
      );
      final repository = BackendAwareSavedLessonsRepository(
        backend: BackendType.supabase,
        local: local,
        remote: remote,
        currentUserId: () => 'user-1',
      );

      await repository.promoteLocalSavesOnSignIn();

      expect(await remote.isSaved('morning-mobility'), isTrue);
      expect(await local.isSaved('morning-mobility'), isTrue);
    });
  });
}
