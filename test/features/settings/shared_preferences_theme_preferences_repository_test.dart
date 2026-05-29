import 'package:pulse_coaching_app/features/settings/data/repositories/shared_preferences_theme_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesThemePreferencesRepository', () {
    late SharedPreferencesThemePreferencesRepository repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      repository = SharedPreferencesThemePreferencesRepository(preferences);
    });

    test('defaults to system theme mode', () async {
      expect(await repository.getThemeMode(), ThemeMode.system);
    });

    test('persists dark theme mode', () async {
      await repository.setThemeMode(ThemeMode.dark);

      expect(await repository.getThemeMode(), ThemeMode.dark);
    });
  });
}
