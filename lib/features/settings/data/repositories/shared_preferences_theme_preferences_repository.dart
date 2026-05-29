import 'package:pulse_coaching_app/features/settings/domain/repositories/theme_preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesThemePreferencesRepository
    implements ThemePreferencesRepository {
  SharedPreferencesThemePreferencesRepository(this._preferences);

  static const _themeModeKey = 'theme_mode';

  final SharedPreferences _preferences;

  @override
  Future<ThemeMode> getThemeMode() async {
    final stored = _preferences.getString(_themeModeKey);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _preferences.setString(_themeModeKey, value);
  }
}
