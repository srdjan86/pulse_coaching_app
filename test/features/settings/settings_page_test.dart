import 'package:pulse_coaching_app/features/settings/data/repositories/in_memory_theme_preferences_repository.dart';
import 'package:pulse_coaching_app/features/settings/presentation/pages/settings_page.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('settings page shows theme mode options', (tester) async {
    final repository = InMemoryThemePreferencesRepository();
    final viewModel = ThemeSettingsViewModel(repository);
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsPage(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
  });

  testWidgets('selecting dark updates view model', (tester) async {
    final repository = InMemoryThemePreferencesRepository();
    final viewModel = ThemeSettingsViewModel(repository);
    await viewModel.load();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsPage(viewModel: viewModel),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(viewModel.themeMode, ThemeMode.dark);
    expect(await repository.getThemeMode(), ThemeMode.dark);
  });
}
