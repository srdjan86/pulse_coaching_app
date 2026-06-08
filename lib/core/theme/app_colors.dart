import 'package:flutter/material.dart';

/// Pulse brand color tokens. Prefer [Theme.of(context).colorScheme] in widgets;
/// use [ThemeExtension] via [AppColors.of] when a named token is clearer.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.primaryPressed,
    required this.surface,
    required this.onSurface,
    required this.mutedForeground,
    required this.error,
    required this.onError,
    required this.surfaceContainer,
    required this.card,
    required this.inputBackground,
    required this.accent,
    required this.border,
  });

  /// Brand primary — CTAs and key accents.
  final Color primary;

  /// Text and icons on [primary].
  final Color onPrimary;

  /// Primary button pressed / loading state.
  final Color primaryPressed;

  /// Screen and scaffold backgrounds.
  final Color surface;

  /// Primary text on [surface].
  final Color onSurface;

  /// Secondary text, labels, and hints.
  final Color mutedForeground;

  /// Errors and destructive emphasis.
  final Color error;

  /// Text and icons on [error].
  final Color onError;

  /// Subtle elevated surfaces (chips, icon backgrounds).
  final Color surfaceContainer;

  /// Card backgrounds on [surface].
  final Color card;

  /// Text field fill color.
  final Color inputBackground;

  /// Secondary accent (highlights, progress).
  final Color accent;

  /// Subtle dividers and outlines.
  final Color border;

  /// Default light palette for Pulse (wellness / coaching).
  static const light = AppColors(
    primary: Color(0xFF0D7377),
    onPrimary: Color(0xFFFFFFFF),
    primaryPressed: Color(0xFF0A5A5E),
    surface: Color(0xFFF5F9F9),
    onSurface: Color(0xFF1A2E2E),
    mutedForeground: Color(0xFF4A6B6B),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFE8F0F0),
    card: Color(0xFFFFFFFF),
    inputBackground: Color(0xFFEDF4F4),
    accent: Color(0xFF14BDBC),
    border: Color(0x1F0D7377),
  );

  /// Dark palette aligned with Figma Make export.
  static const dark = AppColors(
    primary: Color(0xFF0D7377),
    onPrimary: Color(0xFFFFFFFF),
    primaryPressed: Color(0xFF0A5A5E),
    surface: Color(0xFF0E1A1A),
    onSurface: Color(0xFFE8F2F2),
    mutedForeground: Color(0xFF7AACAC),
    error: Color(0xFFCF6679),
    onError: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFF1F3333),
    card: Color(0xFF162424),
    inputBackground: Color(0xFF1F3333),
    accent: Color(0xFF14BDBC),
    border: Color(0x14FFFFFF),
  );

  static AppColors of(BuildContext context) {
    final extension = Theme.of(context).extension<AppColors>();
    if (extension != null) {
      return extension;
    }
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryPressed,
    Color? surface,
    Color? onSurface,
    Color? mutedForeground,
    Color? error,
    Color? onError,
    Color? surfaceContainer,
    Color? card,
    Color? inputBackground,
    Color? accent,
    Color? border,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryPressed: primaryPressed ?? this.primaryPressed,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      card: card ?? this.card,
      inputBackground: inputBackground ?? this.inputBackground,
      accent: accent ?? this.accent,
      border: border ?? this.border,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryPressed: Color.lerp(primaryPressed, other.primaryPressed, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      card: Color.lerp(card, other.card, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
