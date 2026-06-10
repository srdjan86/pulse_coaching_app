import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme.light', () {
    test('maps AppColors to ColorScheme primary surface and error', () {
      const colors = AppColors.light;
      final theme = AppTheme.light(flavor: 'dev');

      expect(theme.colorScheme.primary, colors.primary);
      expect(theme.colorScheme.surface, colors.surface);
      expect(theme.colorScheme.error, colors.error);
      expect(theme.colorScheme.onPrimary, colors.onPrimary);
      expect(theme.colorScheme.onSurface, colors.onSurface);
    });

    test('registers AppColors theme extension', () {
      final theme = AppTheme.light(flavor: 'dev');

      expect(theme.extension<AppColors>(), AppColors.light);
    });

    test('uses flavor accent for tertiary color', () {
      final dev = AppTheme.light(flavor: 'dev');
      final staging = AppTheme.light(flavor: 'staging');

      expect(dev.colorScheme.tertiary, isNot(staging.colorScheme.tertiary));
    });

    test('scaffold and app bar use brand surface', () {
      const colors = AppColors.light;
      final theme = AppTheme.light(flavor: 'dev');

      expect(theme.scaffoldBackgroundColor, colors.surface);
      expect(theme.appBarTheme.backgroundColor, colors.surface);
    });
  });

  group('AppTheme.dark', () {
    test('maps AppColors.dark to ColorScheme', () {
      const colors = AppColors.dark;
      final theme = AppTheme.dark(flavor: 'dev');

      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, colors.primary);
      expect(theme.colorScheme.surface, colors.surface);
      expect(theme.extension<AppColors>(), AppColors.dark);
    });
  });
}
