import 'package:pulse_coaching_app/features/settings/domain/repositories/theme_preferences_repository.dart';
import 'package:flutter/material.dart';

class InMemoryThemePreferencesRepository implements ThemePreferencesRepository {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Future<ThemeMode> getThemeMode() async => _themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
  }
}
