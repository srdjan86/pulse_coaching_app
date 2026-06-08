import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class PulseLogo extends StatelessWidget {
  const PulseLogo({this.showLabel = true, super.key});

  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLogo),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.monitor_heart_outlined,
            color: colors.onPrimary,
            size: 20,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Pulse',
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
        ],
      ],
    );
  }
}
