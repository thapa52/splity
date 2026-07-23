import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// A chip widget that displays a member's name.
///
/// Used in create group screen to show added members,
/// and in group detail screen to show existing members.
///
/// When [onRemove] is provided, shows a remove (x) button.
class MemberChip extends StatelessWidget {
  final String name;
  final VoidCallback? onRemove;

  const MemberChip({super.key, required this.name, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // === AVATAR CIRCLE ===
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // === NAME ===
          Text(
            name,
            style: AppTextStyles.labelMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
          ),

          // === REMOVE BUTTON ===
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(
                Icons.close_rounded,
                size: 18,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
