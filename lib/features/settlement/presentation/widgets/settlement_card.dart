import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/settlement.dart';

/// Displays one settlement transaction.
///
/// Shows: fromMember → toMember with the amount.
/// Visual arrow indicates direction of payment.
class SettlementCard extends StatelessWidget {
  final Settlement settlement;

  const SettlementCard({super.key, required this.settlement});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // === FROM AVATAR ===
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.owes.withValues(alpha: 0.15),
              child: Text(
                settlement.fromMember.isNotEmpty
                    ? settlement.fromMember[0].toUpperCase()
                    : '?',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.owes),
              ),
            ),
            const Gap(8),

            // === FROM NAME ===
            Expanded(
              child: Text(
                settlement.fromMember,
                style: AppTextStyles.labelMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // === ARROW AND AMOUNT ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${AppConstants.currency}${settlement.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ],
              ),
            ),

            const Gap(8),

            // === TO NAME ===
            Expanded(
              child: Text(
                settlement.toMember,
                style: AppTextStyles.labelMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const Gap(8),

            // === TO AVATAR ===
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.owed.withValues(alpha: 0.15),
              child: Text(
                settlement.toMember.isNotEmpty
                    ? settlement.toMember[0].toUpperCase()
                    : '?',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.owed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
