import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_primary_button.dart';
import 'package:pulse_coaching_app/core/widgets/pulse_section_header.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_category_chip.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_player.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoachingVideoDetailPage extends StatelessWidget {
  const CoachingVideoDetailPage({
    required this.videoId,
    this.viewModel,
    this.enablePlayback = true,
    super.key,
  });

  final String videoId;
  final CoachingVideoDetailViewModel? viewModel;
  final bool enablePlayback;

  @override
  Widget build(BuildContext context) {
    final providedViewModel = viewModel;
    if (providedViewModel != null) {
      return ChangeNotifierProvider.value(
        value: providedViewModel,
        child: _CoachingVideoDetailBody(
          videoId: videoId,
          enablePlayback: enablePlayback,
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => getIt<CoachingVideoDetailViewModel>(),
      child: _CoachingVideoDetailBody(
        videoId: videoId,
        enablePlayback: enablePlayback,
      ),
    );
  }
}

class _CoachingVideoDetailBody extends StatefulWidget {
  const _CoachingVideoDetailBody({
    required this.videoId,
    required this.enablePlayback,
  });

  final String videoId;
  final bool enablePlayback;

  @override
  State<_CoachingVideoDetailBody> createState() =>
      _CoachingVideoDetailBodyState();
}

class _CoachingVideoDetailBodyState extends State<_CoachingVideoDetailBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<CoachingVideoDetailViewModel>();
      if (!viewModel.isLoaded && !viewModel.isLoading) {
        viewModel.load(widget.videoId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Consumer<CoachingVideoDetailViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.video == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError) {
            return Center(child: Text(l10n.coachingVideoLoadError));
          }

          final video = viewModel.video;
          if (viewModel.isLoaded && video == null) {
            return Center(child: Text(l10n.coachingVideoNotFound));
          }

          if (video == null) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  CoachingVideoPlayer(
                    video: video,
                    enablePlayback: widget.enablePlayback,
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withValues(alpha: 0.4),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.xl,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PulseCategoryBadge(
                          label: coachingVideoCategoryLabel(
                            video.category,
                            l10n,
                          ),
                          category: video.category,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.schedule,
                          size: 12,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          formatCoachingVideoDuration(video.duration, l10n),
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(video.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PulseSectionHeader(
                            label: l10n.coachingVideoAboutSection,
                          ),
                          Text(
                            video.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    if (widget.enablePlayback) ...[
                      const SizedBox(height: AppSpacing.xl),
                      PulsePrimaryButton(
                        label: l10n.coachingVideoStartSession,
                        icon: Icons.play_arrow,
                        onPressed: () {},
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
