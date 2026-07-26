import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../domain/entities/group.dart';
import '../providers/group_provider.dart';
import '../widgets/member_chip.dart';

/// Screen that displays detailed information about a group.
///
/// Shows group info, members, action buttons, and expenses list.
class GroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupNotifierProvider);
    final expenseState = ref.watch(expenseNotifierProvider(groupId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final group = groupState.groups.where((g) => g.id == groupId).firstOrNull;

    if (groupState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (group == null) {
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
                'Group not found',
                style: AppTextStyles.h3.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(8),
              Text(
                'This group may have been deleted',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
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
        title: Text(group.name),
        actions: [
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref, group),
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete Group',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === GROUP HEADER ===
          _buildHeader(context, group, isDark),
          const Gap(24),

          // === MEMBERS SECTION ===
          _buildMembersSection(context, group, isDark),
          const Gap(24),

          // === ACTION BUTTONS ===
          _buildActionButtons(context, group, isDark),
          const Gap(24),

          // === EXPENSES SECTION ===
          _buildExpensesSection(context, ref, group, expenseState, isDark),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.push('/group/${group.id}/add-expense', extra: group),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Group group, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(group.emoji, style: const TextStyle(fontSize: 40)),
            ),
            const Gap(16),
            Text(
              group.name,
              style: AppTextStyles.h2.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (group.description.isNotEmpty) ...[
              const Gap(8),
              Text(
                group.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 16,
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                const Gap(4),
                Text(
                  '${group.members.length} members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                ),
                const Gap(16),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                const Gap(4),
                Text(
                  _formatDate(group.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersSection(BuildContext context, Group group, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              group.members.map((member) => MemberChip(name: member)).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Group group, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.add_circle_outline_rounded,
                label: 'Add Expense',
                color: AppColors.primary,
                isDark: isDark,
                onTap:
                    () => context.push(
                      '/group/${group.id}/add-expense',
                      extra: group,
                    ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: _ActionCard(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Settlement',
                color: AppColors.secondary,
                isDark: isDark,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Coming soon — Settlement feature'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpensesSection(
    BuildContext context,
    WidgetRef ref,
    Group group,
    ExpenseState expenseState,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === HEADER ROW ===
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Expenses',
              style: AppTextStyles.h3.copyWith(
                color:
                    isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
              ),
            ),
            if (expenseState.hasExpenses)
              Text(
                'Total: ${AppConstants.currency}${expenseState.totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        const Gap(12),

        // === LOADING STATE ===
        if (expenseState.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        // === ERROR STATE ===
        else if (expenseState.hasError)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const Gap(12),
                  Text(
                    expenseState.errorMessage ?? 'Something went wrong',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color:
                          isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(16),
                  ElevatedButton.icon(
                    onPressed:
                        () =>
                            ref
                                .read(expenseNotifierProvider(groupId).notifier)
                                .refresh(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          )
        // === EMPTY STATE ===
        else if (!expenseState.hasExpenses)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color:
                        isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                  ),
                  const Gap(12),
                  Text(
                    'No expenses yet',
                    style: AppTextStyles.labelLarge.copyWith(
                      color:
                          isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'Add your first expense to start tracking',
                    style: AppTextStyles.bodySmall.copyWith(
                      color:
                          isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          )
        // === EXPENSES LIST ===
        else
          ...expenseState.expenses.map(
            (expense) => ExpenseCard(
              expense: expense,
              onTap:
                  () => context.push('/group/$groupId/expense/${expense.id}'),
              onDelete: () async {
                await ref
                    .read(expenseNotifierProvider(groupId).notifier)
                    .removeExpense(expense.id);
              },
            ),
          ),
      ],
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Group group,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Group'),
            content: Text(
              'Are you sure you want to delete "${group.name}"? '
              'This action cannot be undone.',
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
          .read(groupNotifierProvider.notifier)
          .removeGroup(group.id);

      if (context.mounted) {
        if (success) {
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete group'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
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
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const Gap(8),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
