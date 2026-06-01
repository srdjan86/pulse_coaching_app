import 'package:pulse_coaching_app/app/di/service_locator.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/view_models/coaching_video_detail_view_model.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_player.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l10n.coachingVideoDetailTitle)),
      body: Consumer<CoachingVideoDetailViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.video == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
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
            padding: const EdgeInsets.all(16),
            children: [
              CoachingVideoPlayer(
                video: video,
                enablePlayback: widget.enablePlayback,
              ),
              const SizedBox(height: 24),
              Text(video.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text(
                      coachingVideoCategoryLabel(video.category, l10n),
                    ),
                  ),
                  Chip(
                    label: Text(
                      formatCoachingVideoDuration(video.duration, l10n),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(video.description, style: theme.textTheme.bodyLarge),
            ],
          );
        },
      ),
    );
  }
}
