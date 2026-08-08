import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../../expenses/presentation/widgets/expense_card.dart';
import '../../domain/entities/group.dart';
import '../providers/group_provider.dart';
import '../widgets/member_chip.dart';

/// Screen that displays detailed information about a group.
///
/// Shows group info, members, expense stats,
/// action buttons, and expenses list.
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
      return const Scaffold(body: LoadingWidget(message: 'Loading group...'));
    }

    if (group == null) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyStateWidget(
          icon: Icons.search_off_rounded,
          title: 'Group not found',
          subtitle: 'This group may have been deleted',
          buttonLabel: 'Go Back',
          onButtonPressed: () => context.pop(),
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
      body: RefreshIndicator(
        onRefresh:
            () => ref.read(expenseNotifierProvider(groupId).notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // === GROUP HEADER ===
                  _buildHeader(context, group, isDark),
                  const Gap(16),

                  // === EXPENSE STATS ===
                  if (expenseState.hasExpenses) ...[
                    _buildExpenseStats(expenseState, isDark),
                    const Gap(16),
                  ],

                  // === MEMBERS SECTION ===
                  _buildMembersSection(context, group, isDark),
                  const Gap(16),

                  // === ACTION BUTTONS ===
                  _buildActionButtons(context, group, isDark),
                  const Gap(24),

                  // === EXPENSES HEADER ===
                  _buildExpensesHeader(expenseState, isDark),
                  const Gap(12),
                ]),
              ),
            ),

            // === EXPENSES LIST ===
            if (expenseState.isLoading)
              const SliverToBoxAdapter(
                child: LoadingWidget(message: 'Loading expenses...'),
              )
            else if (expenseState.hasError)
              SliverToBoxAdapter(
                child: AppErrorWidget(
                  message:
                      expenseState.errorMessage ?? 'Failed to load expenses',
                  onRetry:
                      () =>
                          ref
                              .read(expenseNotifierProvider(groupId).notifier)
                              .refresh(),
                ),
              )
            else if (!expenseState.hasExpenses)
              SliverToBoxAdapter(
                child: EmptyStateWidget(
                  icon: Icons.receipt_long_outlined,
                  title: 'No expenses yet',
                  subtitle: 'Add your first expense to start tracking',
                  buttonLabel: 'Add Expense',
                  onButtonPressed:
                      () => context.push(
                        '/group/${group.id}/add-expense',
                        extra: group,
                      ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final expense = expenseState.expenses[index];
                  return ExpenseCard(
                    expense: expense,
                    onTap:
                        () => context.push(
                          '/group/$groupId/expense/${expense.id}',
                        ),
                    onDelete: () async {
                      await ref
                          .read(expenseNotifierProvider(groupId).notifier)
                          .removeExpense(expense.id);
                    },
                  );
                }, childCount: expenseState.expenses.length),
              ),

            // === BOTTOM PADDING FOR FAB ===
            const SliverToBoxAdapter(child: Gap(100)),
          ],
        ),
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
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(group.emoji, style: const TextStyle(fontSize: 36)),
            ),
            const Gap(12),
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
              const Gap(6),
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

  Widget _buildExpenseStats(ExpenseState expenseState, bool isDark) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                label: 'Expenses',
                value: '${expenseState.expenses.length}',
                icon: Icons.receipt_rounded,
                color: AppColors.primary,
                isDark: isDark,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
                  .withValues(alpha: 0.2),
            ),
            Expanded(
              child: _buildStatItem(
                label: 'Total Spent',
                value:
                    '${AppConstants.currency}${expenseState.totalAmount.toStringAsFixed(0)}',
                icon: Icons.currency_rupee_rounded,
                color: AppColors.secondary,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const Gap(6),
        Text(value, style: AppTextStyles.h3.copyWith(color: color)),
        const Gap(2),
        Text(
          label,
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
    return Row(
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
            onTap: () => context.push('/group/${group.id}/settlement'),
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesHeader(ExpenseState expenseState, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expenses',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        if (expenseState.hasExpenses)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Total: ${AppConstants.currency}${expenseState.totalAmount.toStringAsFixed(2)}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
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
