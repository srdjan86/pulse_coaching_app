import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/features/settings/presentation/view_models/theme_settings_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.viewModel});

  final ThemeSettingsViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel ?? getIt<ThemeSettingsViewModel>(),
      child: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Consumer<ThemeSettingsViewModel>(
        builder: (context, viewModel, _) {
          if (!viewModel.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.themeSectionTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l10n.themeModeSystem),
                    icon: const Icon(Icons.brightness_auto_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l10n.themeModeLight),
                    icon: const Icon(Icons.light_mode_outlined),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l10n.themeModeDark),
                    icon: const Icon(Icons.dark_mode_outlined),
                  ),
                ],
                selected: {viewModel.themeMode},
                onSelectionChanged: (selection) {
                  viewModel.setThemeMode(selection.first);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
