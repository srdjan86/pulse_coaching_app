import 'package:pulse_coaching_app/core/theme/app_colors.dart';
import 'package:pulse_coaching_app/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class PulsePrimaryButton extends StatelessWidget {
  const PulsePrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.buttonKey,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return FilledButton(
      key: buttonKey,
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isLoading ? colors.primaryPressed : colors.primary,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.onPrimary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                if (icon != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(icon, size: 18),
                ],
              ],
            ),
    );
  }
}
