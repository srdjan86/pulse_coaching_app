import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      secondary: colors.accent,
      onSecondary: colors.onPrimary,
      tertiary: flavorAccent,
      onTertiary: colors.onPrimary,
      error: colors.error,
      onError: colors.onError,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceContainer,
    );

    final textTheme = _textTheme(colors);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      extensions: [colors],
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          side: BorderSide(color: colors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.minButtonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBackground,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colors.mutedForeground,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.mutedForeground),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide(color: colors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide(color: colors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
        errorStyle: textTheme.labelMedium?.copyWith(color: colors.error),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainer,
        labelStyle: textTheme.labelSmall,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return brightness == Brightness.dark
                  ? colors.primary
                  : colors.card;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return brightness == Brightness.dark
                  ? colors.onPrimary
                  : colors.primary;
            }
            return colors.mutedForeground;
          }),
        ),
      ),
    );
  }

  static TextTheme _textTheme(AppColors colors) {
    final fallback = ThemeData(useMaterial3: true).textTheme;
    final base = GoogleFonts.config.allowRuntimeFetching
        ? GoogleFonts.dmSansTextTheme(fallback)
        : fallback;
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        height: 1.1,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: colors.mutedForeground,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: colors.onSurface.withValues(alpha: 0.85),
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: colors.mutedForeground,
        height: 1.45,
      ),
      bodySmall: base.bodySmall?.copyWith(color: colors.mutedForeground),
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
