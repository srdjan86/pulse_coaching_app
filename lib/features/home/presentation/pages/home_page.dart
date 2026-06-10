import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/config/app_config.dart';
import 'package:pulse_coaching_app/core/config/app_flavor.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_feature_card.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_section_header.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_category_chip.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.viewModel});

  final HomeViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    final providedViewModel = viewModel;
    if (providedViewModel != null) {
      return ChangeNotifierProvider.value(
        value: providedViewModel,
        child: const _HomeBody(),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => getIt<HomeViewModel>(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<HomeViewModel>();
      if (!viewModel.isLoaded) {
        viewModel.load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = getIt<AppConfig>();
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeGreeting,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(l10n.appTitle, style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: l10n.settingsTitle,
                  color: colors.mutedForeground,
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _FocusHero(label: l10n.homeFocusLabel, quote: l10n.homeFocusQuote),
            const SizedBox(height: AppSpacing.xl),
            PulseSectionHeader(label: l10n.homeExploreSection),
            PulseFeatureCard(
              title: l10n.coachingVideosTitle,
              subtitle: l10n.coachingVideosDescription,
              icon: Icons.play_circle_outline,
              badge: viewModel.sessionCount > 0
                  ? l10n.coachingVideosSessionCount(viewModel.sessionCount)
                  : null,
              onTap: () => context.push('/coaching-videos'),
            ),
            if (viewModel.continueVideos.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              PulseSectionHeader(label: l10n.homeContinueSection),
              ...viewModel.continueVideos.map(
                (video) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ContinueLessonTile(
                    video: video,
                    onTap: () => context.push('/coaching-videos/${video.id}'),
                  ),
                ),
              ),
            ] else if (viewModel.hasError) ...[
              const SizedBox(height: AppSpacing.xl),
              _HomeNotice(message: l10n.homeContinueLoadError),
            ],
            if (config.flavor == AppFlavor.dev) ...[
              const SizedBox(height: AppSpacing.xl),
              PulseSectionHeader(label: l10n.homeDevSection),
              PulseFeatureCard(
                title: l10n.counterTitle,
                subtitle: l10n.counterDescription,
                icon: Icons.exposure_plus_1_outlined,
                onTap: () => context.push('/counter'),
              ),
              const SizedBox(height: AppSpacing.md),
              PulseFeatureCard(
                title: l10n.loginTitle,
                subtitle: l10n.authDescription,
                icon: Icons.login_outlined,
                onTap: () => context.push('/login'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.flavorLabel(config.flavor.name),
                style: theme.textTheme.bodySmall,
              ),
              Text(
                l10n.backendLabel(config.backend.name),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FocusHero extends StatelessWidget {
  const _FocusHero({required this.label, required this.quote});

  final String label;
  final String quote;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusHero),
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            quote,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.onPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNotice extends StatelessWidget {
  const _HomeNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        border: Border.all(color: colors.border),
      ),
      child: Text(message, style: theme.textTheme.bodyMedium),
    );
  }
}

class _ContinueLessonTile extends StatelessWidget {
  const _ContinueLessonTile({required this.video, required this.onTap});

  final CoachingVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final theme = Theme.of(context);
    final style = coachingVideoCategoryStyle(video.category);

    return Material(
      color: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.iconTileSize,
                height: AppSpacing.iconTileSize,
                decoration: BoxDecoration(
                  color: style.foreground,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLogo),
                ),
                child: Icon(Icons.play_arrow, color: colors.onPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title, style: theme.textTheme.titleSmall),
                    Text(
                      '${coachingVideoCategoryLabel(video.category, l10n)} · ${formatCoachingVideoDuration(video.duration, l10n)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colors.mutedForeground,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
