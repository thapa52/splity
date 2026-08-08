import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// A consistent empty state widget used across the app.
///
/// Shows an icon, title, subtitle, and optional action button.
/// Used when a list or screen has no data to display.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // === ICON CONTAINER ===
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
            const Gap(24),

            // === TITLE ===
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),

            // === SUBTITLE ===
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            // === OPTIONAL BUTTON ===
            if (buttonLabel != null && onButtonPressed != null) ...[
              const Gap(24),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
