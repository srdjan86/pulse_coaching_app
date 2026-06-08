import 'package:pulse_coaching_app/app/di/service_locator.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l10n.coachingVideosTitle)),
      body: Consumer<CoachingVideoLibraryViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.videos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text(l10n.coachingVideoLoadError));
          }

          if (viewModel.isLoaded && viewModel.videos.isEmpty) {
            return Center(child: Text(l10n.coachingVideosEmpty));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.videos.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final video = viewModel.videos[index];
              return CoachingVideoCard(
                video: video,
                onTap: () => context.push('/coaching-videos/${video.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
