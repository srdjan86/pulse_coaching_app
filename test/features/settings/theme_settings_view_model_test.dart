import 'package:pulse_coaching_app/features/settings/data/repositories/in_memory_theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeSettingsViewModel', () {
    late InMemoryThemePreferencesRepository repository;
    late ThemeSettingsViewModel viewModel;

    setUp(() {
      repository = InMemoryThemePreferencesRepository();
      viewModel = ThemeSettingsViewModel(repository);
    });

    test('load restores persisted theme mode', () async {
      await repository.setThemeMode(ThemeMode.dark);

      await viewModel.load();

      expect(viewModel.themeMode, ThemeMode.dark);
      expect(viewModel.isLoaded, isTrue);
    });

    test('setThemeMode updates state and persists', () async {
      await viewModel.load();

      await viewModel.setThemeMode(ThemeMode.light);

      expect(viewModel.themeMode, ThemeMode.light);
      expect(await repository.getThemeMode(), ThemeMode.light);
    });
  });
}
