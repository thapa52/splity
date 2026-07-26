import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/split_summary_card.dart';

/// Screen that displays the full details of an expense.
///
/// Shows:
/// - Amount and title
/// - Category and date
/// - Who paid
/// - Full split breakdown
/// - Delete option
class ExpenseDetailScreen extends ConsumerWidget {
  final String groupId;
  final String expenseId;

  const ExpenseDetailScreen({
    super.key,
    required this.groupId,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseNotifierProvider(groupId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final expense =
        expenseState.expenses.where((e) => e.id == expenseId).firstOrNull;

    if (expenseState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (expense == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              const Gap(16),
              Text(
                'Expense not found',
                style: AppTextStyles.h3.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref, expense),
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Expense',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === AMOUNT HEADER ===
          _buildAmountHeader(expense, isDark),
          const Gap(24),

          // === DETAILS CARD ===
          _buildDetailsCard(expense, isDark),
          const Gap(24),

          // === SPLIT BREAKDOWN ===
          SplitSummaryCard(
            splits: expense.splits,
            paidBy: expense.paidBy,
            totalAmount: expense.amount,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountHeader(Expense expense, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // === CATEGORY ICON ===
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _getCategoryColor(
                  expense.category,
                ).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                _getCategoryIcon(expense.category),
                color: _getCategoryColor(expense.category),
                size: 32,
              ),
            ),
            const Gap(16),

            // === AMOUNT ===
            Text(
              '${AppConstants.currency}${expense.amount.toStringAsFixed(2)}',
              style: AppTextStyles.h1.copyWith(color: AppColors.primary),
            ),
            const Gap(8),

            // === TITLE ===
            Text(
              expense.title,
              style: AppTextStyles.h3.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            // === DESCRIPTION ===
            if (expense.description.isNotEmpty) ...[
              const Gap(8),
              Text(
                expense.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Expense expense, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // === PAID BY ===
            _buildDetailRow(
              icon: Icons.person_rounded,
              label: 'Paid by',
              value: expense.paidBy,
              isDark: isDark,
            ),
            const Divider(height: 24),

            // === CATEGORY ===
            _buildDetailRow(
              icon: _getCategoryIcon(expense.category),
              label: 'Category',
              value: expense.category,
              isDark: isDark,
            ),
            const Divider(height: 24),

            // === DATE ===
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: _formatDate(expense.createdAt),
              isDark: isDark,
            ),
            const Divider(height: 24),

            // === SPLIT TYPE ===
            _buildDetailRow(
              icon: Icons.pie_chart_outline_rounded,
              label: 'Split',
              value: _getSplitType(expense),
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
        ),
        const Gap(12),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  /// Determines if the split is equal or unequal.
  String _getSplitType(Expense expense) {
    if (expense.splits.isEmpty) return 'Unknown';
    final firstAmount = expense.splits.first.amount;
    final isEqual = expense.splits.every(
      (s) => (s.amount - firstAmount).abs() < 0.02,
    );
    return isEqual ? 'Equal' : 'Unequal';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant_rounded;
      case 'Transport':
        return Icons.directions_car_rounded;
      case 'Shopping':
        return Icons.shopping_bag_rounded;
      case 'Entertainment':
        return Icons.movie_rounded;
      case 'Utilities':
        return Icons.bolt_rounded;
      case 'Rent':
        return Icons.home_rounded;
      default:
        return Icons.receipt_rounded;
    }
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

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Expense'),
            content: Text(
              'Are you sure you want to delete "${expense.title}"?\n'
              'This will affect the group balance.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (result == true && context.mounted) {
      final success = await ref
          .read(expenseNotifierProvider(groupId).notifier)
          .removeExpense(expense.id);

      if (context.mounted) {
        if (success) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete expense'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
