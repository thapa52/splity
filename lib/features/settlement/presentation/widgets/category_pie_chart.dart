import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../expenses/domain/entities/expense.dart';

/// A pie chart showing expense distribution by category.
///
/// Each slice represents one category's total amount
/// with color coding matching the expense category colors.
class CategoryPieChart extends StatelessWidget {
  final List<Expense> expenses;

  const CategoryPieChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (expenses.isEmpty) return const SizedBox.shrink();

    final categoryTotals = _calculateCategoryTotals();
    final totalAmount = categoryTotals.values.fold<double>(
      0,
      (sum, amount) => sum + amount,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses by Category',
              style: AppTextStyles.labelLarge.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            const Gap(4),
            Text(
              'Total: ${AppConstants.currency}${totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
            const Gap(20),

            // === PIE CHART ===
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections:
                      categoryTotals.entries.map((entry) {
                        final percentage = (entry.value / totalAmount) * 100;
                        return PieChartSectionData(
                          value: entry.value,
                          title: '${percentage.toStringAsFixed(0)}%',
                          color: _getCategoryColor(entry.key),
                          radius: 50,
                          titleStyle: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const Gap(20),

            // === LEGEND ===
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children:
                  categoryTotals.entries.map((entry) {
                    return _buildLegendItem(
                      category: entry.key,
                      amount: entry.value,
                      isDark: isDark,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required String category,
    required double amount,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _getCategoryColor(category),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const Gap(6),
        Text(
          '$category: ${AppConstants.currency}${amount.toStringAsFixed(2)}',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  /// Groups expenses by category and sums their amounts.
  Map<String, double> _calculateCategoryTotals() {
    final totals = <String, double>{};

    for (final expense in expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }

    // Sort by amount — largest first
    final sorted = Map.fromEntries(
      totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );

    return sorted;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return AppColors.food;
      case 'Transport':
        return AppColors.transport;
      case 'Shopping':
        return AppColors.shopping;
      case 'Entertainment':
        return AppColors.entertainment;
      case 'Utilities':
        return AppColors.utilities;
      case 'Rent':
        return AppColors.rent;
      default:
        return AppColors.other;
    }
  }
}
