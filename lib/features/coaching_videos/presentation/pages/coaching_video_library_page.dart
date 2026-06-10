import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_category_chip.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_library_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_card.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoachingVideoLibraryPage extends StatelessWidget {
  const CoachingVideoLibraryPage({super.key, this.viewModel});

  final CoachingVideoLibraryViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    final providedViewModel = viewModel;
    if (providedViewModel != null) {
      return ChangeNotifierProvider.value(
        value: providedViewModel,
        child: const _CoachingVideoLibraryBody(),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => getIt<CoachingVideoLibraryViewModel>(),
      child: const _CoachingVideoLibraryBody(),
    );
  }
}

class _CoachingVideoLibraryBody extends StatefulWidget {
  const _CoachingVideoLibraryBody();

  @override
  State<_CoachingVideoLibraryBody> createState() =>
      _CoachingVideoLibraryBodyState();
}

class _CoachingVideoLibraryBodyState extends State<_CoachingVideoLibraryBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<CoachingVideoLibraryViewModel>();
      if (!viewModel.isLoaded && !viewModel.isLoading) {
        viewModel.load();
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
      body: SafeArea(
        bottom: false,
        child: Consumer<CoachingVideoLibraryViewModel>(
          builder: (context, viewModel, _) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.lg,
                      AppSpacing.screenHorizontal,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: colors.mutedForeground,
                              onPressed: () => context.pop(),
                            ),
                            Text(
                              l10n.coachingVideosTitle,
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              PulseCategoryChip(
                                label: l10n.coachingVideoCategoryAll,
                                selected: viewModel.selectedCategory == null,
                                onTap: () => viewModel.selectCategory(null),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              ...CoachingVideoCategory.values.map(
                                (category) => Padding(
                                  padding: const EdgeInsets.only(
                                    right: AppSpacing.sm,
                                  ),
                                  child: PulseCategoryChip(
                                    label: coachingVideoCategoryLabel(
                                      category,
                                      l10n,
                                    ),
                                    selected:
                                        viewModel.selectedCategory == category,
                                    onTap: () =>
                                        viewModel.selectCategory(category),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (viewModel.isLoading && viewModel.videos.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (viewModel.hasError)
                  SliverFillRemaining(
                    child: Center(child: Text(l10n.coachingVideoLoadError)),
                  )
                else if (viewModel.isLoaded && viewModel.filteredVideos.isEmpty)
                  SliverFillRemaining(
                    child: Center(child: Text(l10n.coachingVideosEmpty)),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      0,
                      AppSpacing.screenHorizontal,
                      AppSpacing.xxl,
                    ),
                    sliver: SliverList.separated(
                      itemCount: viewModel.filteredVideos.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final video = viewModel.filteredVideos[index];
                        return CoachingVideoCard(
                          video: video,
                          onTap: () =>
                              context.push('/coaching-videos/${video.id}'),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
