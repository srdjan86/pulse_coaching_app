import 'package:flutter/material.dart';

/// Pulse brand color tokens. Prefer [Theme.of(context).colorScheme] in widgets;
/// use [ThemeExtension] via [AppColors.of] when a named token is clearer.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.error,
    required this.onError,
    required this.surfaceContainer,
  });

  /// Brand primary — CTAs and key accents.
  final Color primary;

  /// Text and icons on [primary].
  final Color onPrimary;

  /// Screen and scaffold backgrounds.
  final Color surface;

  /// Primary text on [surface].
  final Color onSurface;

  /// Errors and destructive emphasis.
  final Color error;

  /// Text and icons on [error].
  final Color onError;

  /// Elevated surfaces such as cards.
  final Color surfaceContainer;

  /// Default light palette for Pulse (wellness / coaching).
  static const light = AppColors(
    primary: Color(0xFF0D7377),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFFF5F9F9),
    onSurface: Color(0xFF1A2E2E),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFE8F0F0),
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
    Color? error,
    Color? onError,
    Color? surfaceContainer,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
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
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
    );
  }
}
