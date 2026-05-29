import 'package:flutter/material.dart';

abstract class ThemePreferencesRepository {
  Future<ThemeMode> getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);
}
