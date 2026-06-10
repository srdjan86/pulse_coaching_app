import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:pulse_coaching_app/features/coaching_videos/domain/entities/coaching_video.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_category_chip.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/utils/coaching_video_localization.dart';
import 'package:pulse_coaching_app/features/coaching_videos/presentation/widgets/coaching_video_thumbnail.dart';
import 'package:pulse_coaching_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CoachingVideoCard extends StatelessWidget {
  const CoachingVideoCard({
    required this.video,
    required this.onTap,
    super.key,
  });

  final CoachingVideo video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Material(
      color: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoachingVideoThumbnail(
              category: video.category,
              title: video.title,
              thumbnailUrl: video.thumbnailUrl,
              borderRadius: BorderRadius.zero,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PulseCategoryBadge(
                        label: coachingVideoCategoryLabel(video.category, l10n),
                        category: video.category,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Icon(
                        Icons.schedule,
                        size: 11,
                        color: colors.mutedForeground,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        formatCoachingVideoDuration(video.duration, l10n),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(video.title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    video.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
