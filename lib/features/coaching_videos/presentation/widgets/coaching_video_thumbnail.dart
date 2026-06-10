import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_category_chip.dart';
import 'package:flutter/material.dart';

class CoachingVideoThumbnail extends StatelessWidget {
  const CoachingVideoThumbnail({
    required this.category,
    required this.title,
    this.thumbnailUrl,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppSpacing.radiusCard),
    ),
    super.key,
  });

  final CoachingVideoCategory category;
  final String title;
  final Uri? thumbnailUrl;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final style = coachingVideoCategoryStyle(category);

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (thumbnailUrl != null)
              Image.network(
                thumbnailUrl.toString(),
                fit: BoxFit.cover,
                semanticLabel: title,
                errorBuilder: (context, error, stackTrace) =>
                    ColoredBox(color: colors.surfaceContainer),
              )
            else
              ColoredBox(color: colors.surfaceContainer),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                  stops: const [0.5, 1],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: style.foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
