import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';

/// A horizontal bar chart showing net balance per member.
///
/// Green bars = owed money (positive balance)
/// Red bars = owes money (negative balance)
class BalanceBarChart extends StatelessWidget {
  final Map<String, double> netBalances;

  const BalanceBarChart({super.key, required this.netBalances});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (netBalances.isEmpty) return const SizedBox.shrink();

    // Sort by balance value — largest positive first
    final sortedEntries =
        netBalances.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    final maxAbsValue = sortedEntries
        .map((e) => e.value.abs())
        .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Balance Overview',
              style: AppTextStyles.labelLarge.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            const Gap(4),
            Text(
              'Net balance per member',
              style: AppTextStyles.bodySmall.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
            ),
            const Gap(20),
            SizedBox(
              height: sortedEntries.length * 52.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAbsValue * 1.2,
                  minY: -maxAbsValue * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final entry = sortedEntries[group.x.toInt()];
                        return BarTooltipItem(
                          '${entry.key}\n${AppConstants.currency}${entry.value.abs().toStringAsFixed(2)}',
                          AppTextStyles.bodySmall.copyWith(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= sortedEntries.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              sortedEntries[index].key,
                              style: AppTextStyles.bodySmall.copyWith(
                                color:
                                    isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${AppConstants.currency}${value.toInt()}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                              fontSize: 9,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxAbsValue / 3,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight)
                            .withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      sortedEntries.asMap().entries.map((entry) {
                        final index = entry.key;
                        final balance = entry.value.value;
                        final isPositive = balance > 0;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: balance,
                              color:
                                  isPositive ? AppColors.owed : AppColors.owes,
                              width: 20,
                              borderRadius:
                                  isPositive
                                      ? const BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      )
                                      : const BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
