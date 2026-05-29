import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({required String flavor}) {
    return _build(
      colors: AppColors.light,
      flavor: flavor,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark({required String flavor}) {
    return _build(
      colors: AppColors.dark,
      flavor: flavor,
      brightness: Brightness.dark,
    );
  }

  static ThemeData _build({
    required AppColors colors,
    required String flavor,
    required Brightness brightness,
  }) {
    final flavorAccent = _flavorAccentColor(flavor);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: flavorAccent,
      onSecondary: colors.onPrimary,
      error: colors.error,
      onError: colors.onError,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceContainer,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: colors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainer,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
      textTheme: _textTheme(colors),
    );
  }

  static TextTheme _textTheme(AppColors colors) {
    return TextTheme(
      headlineMedium: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: colors.onSurface.withValues(alpha: 0.85)),
      bodyMedium: TextStyle(color: colors.onSurface.withValues(alpha: 0.75)),
    );
  }

  /// Subtle flavor accent for secondary elements (not the core brand primary).
  static Color _flavorAccentColor(String flavor) {
    return switch (flavor) {
      'prod' => const Color(0xFF3949AB),
      'staging' => const Color(0xFFE65100),
      _ => const Color(0xFF00897B),
    };
  }
}
