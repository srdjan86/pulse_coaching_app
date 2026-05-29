import 'package:pulse_coaching_app/features/settings/domain/repositories/theme_preferences_repository.dart';
import 'package:flutter/material.dart';

class ThemeSettingsViewModel extends ChangeNotifier {
  ThemeSettingsViewModel(this._repository);

  final ThemePreferencesRepository _repository;

  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoaded = false;

  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    _themeMode = await _repository.getThemeMode();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    await _repository.setThemeMode(mode);
  }
}
