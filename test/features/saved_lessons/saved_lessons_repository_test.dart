import 'package:pulse_coaching_app/features/saved_lessons/data/repositories/shared_preferences_saved_lessons_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesSavedLessonsRepository', () {
    late SharedPreferencesSavedLessonsRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      repository = SharedPreferencesSavedLessonsRepository(preferences);
    });

    test('starts with no saved lessons', () async {
      expect(await repository.getSavedLessonIds(), isEmpty);
      expect(await repository.isSaved('morning-mobility'), isFalse);
    });

    test('saves and removes lessons', () async {
      await repository.save('morning-mobility');

      expect(await repository.isSaved('morning-mobility'), isTrue);
      expect(await repository.getSavedLessonIds(), {'morning-mobility'});

      await repository.unsave('morning-mobility');

      expect(await repository.isSaved('morning-mobility'), isFalse);
      expect(await repository.getSavedLessonIds(), isEmpty);
    });
  });
}
