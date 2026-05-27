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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.homeSubtitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.flavorLabel(config.flavor.name)),
          Text(l10n.backendLabel(config.backend.name)),
          const SizedBox(height: 24),
          _FeatureCard(
            title: l10n.counterTitle,
            description: l10n.counterDescription,
            onTap: () => context.push('/counter'),
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            title: l10n.authTitle,
            description: l10n.authDescription,
            onTap: () => context.push('/auth'),
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
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
