import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_card.dart';
import 'package:pulse_coaching_app/features/saved_lessons/presentation/view_models/saved_lessons_view_model.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SavedLessonsPage extends StatelessWidget {
  const SavedLessonsPage({super.key, this.viewModel});

  final SavedLessonsViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    final providedViewModel = viewModel;
    if (providedViewModel != null) {
      return ChangeNotifierProvider.value(
        value: providedViewModel,
        child: const _SavedLessonsBody(),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => getIt<SavedLessonsViewModel>(),
      child: const _SavedLessonsBody(),
    );
  }
}

class _SavedLessonsBody extends StatefulWidget {
  const _SavedLessonsBody();

  @override
  State<_SavedLessonsBody> createState() => _SavedLessonsBodyState();
}

class _SavedLessonsBodyState extends State<_SavedLessonsBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<SavedLessonsViewModel>();
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
        child: Consumer<SavedLessonsViewModel>(
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
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: colors.mutedForeground,
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Text(
                            l10n.savedLessonsTitle,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (viewModel.isLoading && viewModel.savedVideos.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (viewModel.hasError)
                  SliverFillRemaining(
                    child: Center(child: Text(l10n.savedLessonsLoadError)),
                  )
                else if (viewModel.isLoaded && viewModel.savedVideos.isEmpty)
                  SliverFillRemaining(
                    child: Center(child: Text(l10n.savedLessonsEmpty)),
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
                      itemCount: viewModel.savedVideos.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final video = viewModel.savedVideos[index];
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
