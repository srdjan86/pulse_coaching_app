import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = getIt<AppConfig>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.homeSubtitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            l10n.flavorLabel(config.flavor.name),
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            l10n.backendLabel(config.backend.name),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _FeatureCard(
            title: l10n.counterTitle,
            description: l10n.counterDescription,
            onTap: () => context.push('/counter'),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            title: l10n.loginTitle,
            description: l10n.authDescription,
            onTap: () => context.push('/login'),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(description, style: theme.textTheme.bodyMedium),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
        onTap: onTap,
      ),
    );
  }
}
