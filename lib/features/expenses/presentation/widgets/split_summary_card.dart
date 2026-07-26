import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/expense_split.dart';

/// A card that displays how an expense is split among members.
///
/// Shows each member's name and their share amount.
/// Highlights who paid with a special badge.
///
/// Used in:
/// - Add expense screen (preview before saving)
/// - Expense detail screen (view split breakdown)
class SplitSummaryCard extends StatelessWidget {
  final List<ExpenseSplit> splits;
  final String paidBy;
  final double totalAmount;

  const SplitSummaryCard({
    super.key,
    required this.splits,
    required this.paidBy,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Split Breakdown',
                  style: AppTextStyles.labelLarge.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  '${AppConstants.currency}${totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.amountSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),

            // === SPLIT LIST ===
            ...splits.map((split) => _buildSplitRow(split, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitRow(ExpenseSplit split, bool isDark) {
    final isPayer = split.memberName == paidBy;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // === AVATAR ===
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isPayer
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              split.memberName.isNotEmpty
                  ? split.memberName[0].toUpperCase()
                  : '?',
              style: AppTextStyles.bodySmall.copyWith(
                color: isPayer ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(12),

          // === NAME + PAID BADGE ===
          Expanded(
            child: Row(
              children: [
                Text(
                  split.memberName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color:
                        isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                  ),
                ),
                if (isPayer) ...[
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'paid',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // === AMOUNT ===
          Text(
            '${AppConstants.currency}${split.amount.toStringAsFixed(2)}',
            style: AppTextStyles.labelMedium.copyWith(
              color:
                  isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
