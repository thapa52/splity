import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Displays one member's net balance in a group.
///
/// Shows whether the member is owed money (green),
/// owes money (red), or is settled (grey).
class BalanceCard extends StatelessWidget {
  final String memberName;
  final double netBalance;

  const BalanceCard({
    super.key,
    required this.memberName,
    required this.netBalance,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOwed = netBalance > 0.01;
    final isOwing = netBalance < -0.01;
    final isSettled = !isOwed && !isOwing;

    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (isOwed) {
      statusColor = AppColors.owed;
      statusText = 'gets back';
      statusIcon = Icons.arrow_downward_rounded;
    } else if (isOwing) {
      statusColor = AppColors.owes;
      statusText = 'owes';
      statusIcon = Icons.arrow_upward_rounded;
    } else {
      statusColor = AppColors.settled;
      statusText = 'settled';
      statusIcon = Icons.check_circle_outline_rounded;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // === AVATAR ===
            CircleAvatar(
              radius: 20,
              backgroundColor: statusColor.withValues(alpha: 0.15),
              child: Text(
                memberName.isNotEmpty ? memberName[0].toUpperCase() : '?',
                style: AppTextStyles.labelLarge.copyWith(color: statusColor),
              ),
            ),
            const Gap(12),

            // === NAME AND STATUS ===
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memberName,
                    style: AppTextStyles.labelLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    statusText,
                    style: AppTextStyles.bodySmall.copyWith(color: statusColor),
                  ),
                ],
              ),
            ),

            // === AMOUNT ===
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 16),
                const Gap(4),
                Text(
                  isSettled
                      ? 'All clear'
                      : '${AppConstants.currency}${netBalance.abs().toStringAsFixed(2)}',
                  style: AppTextStyles.amountSmall.copyWith(color: statusColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
