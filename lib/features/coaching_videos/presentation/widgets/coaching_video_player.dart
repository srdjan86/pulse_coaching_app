import 'package:chewie/chewie.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_thumbnail.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CoachingVideoPlayer extends StatefulWidget {
  const CoachingVideoPlayer({
    required this.video,
    this.enablePlayback = true,
    super.key,
  });

  final CoachingVideo video;
  final bool enablePlayback;

  @override
  State<CoachingVideoPlayer> createState() => _CoachingVideoPlayerState();
}

class _CoachingVideoPlayerState extends State<CoachingVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  Future<void>? _initializeFuture;

  @override
  void initState() {
    super.initState();
    if (widget.enablePlayback) {
      _initializePlayer();
    }
  }

  @override
  void didUpdateWidget(CoachingVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.videoUrl != widget.video.videoUrl ||
        oldWidget.enablePlayback != widget.enablePlayback) {
      _disposeControllers();
      if (widget.enablePlayback) {
        _initializePlayer();
      } else {
        _initializeFuture = null;
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializePlayer() {
    final videoController = VideoPlayerController.networkUrl(
      widget.video.videoUrl,
    );
    _videoController = videoController;
    _initializeFuture = videoController.initialize().then((_) {
      if (!mounted) return;
      _chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
      );
      setState(() {});
    });
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (!widget.enablePlayback) {
      return _PlayerFallback(video: widget.video);
    }

    return FutureBuilder<void>(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || _chewieController == null) {
          return _PlayerFallback(
            video: widget.video,
            label: l10n.coachingVideoPlayerUnavailable,
          );
        }

        return AspectRatio(
          aspectRatio: _videoController?.value.aspectRatio ?? 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Chewie(controller: _chewieController!),
          ),
        );
      },
    );
  }
}

class _PlayerFallback extends StatelessWidget {
  const _PlayerFallback({required this.video, this.label});

  final CoachingVideo video;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        CoachingVideoThumbnail(
          category: video.category,
          title: video.title,
          thumbnailUrl: video.thumbnailUrl,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label ?? l10n.coachingVideoPlayerMockHint,
              style: theme.textTheme.labelLarge,
            ),
          ),
        ),
      ],
    );
  }
}
