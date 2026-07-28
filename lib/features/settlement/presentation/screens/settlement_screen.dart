import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/settlement_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/settlement_card.dart';

/// Screen that shows the settlement summary for a group.
///
/// Displays:
/// - Net balance for each member
/// - Minimum transactions needed to settle all debts
/// - All settled state when no debts exist
class SettlementScreen extends ConsumerWidget {
  final String groupId;

  const SettlementScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settlementNotifierProvider(groupId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settlement')),
      body: _buildBody(context, state, isDark),
    );
  }

  Widget _buildBody(BuildContext context, SettlementState state, bool isDark) {
    // === LOADING ===
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // === ERROR ===
    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
              const Gap(16),
              Text(
                state.errorMessage ?? 'Something went wrong',
                style: AppTextStyles.bodyLarge.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // === NO EXPENSES ===
    if (state.netBalances.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              const Gap(16),
              Text(
                'No expenses yet',
                style: AppTextStyles.h3.copyWith(
                  color:
                      isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(8),
              Text(
                'Add expenses to see the settlement summary',
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // === SETTLEMENT DATA ===
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // === STATUS BANNER ===
        _buildStatusBanner(state, isDark),
        const Gap(24),

        // === NET BALANCES ===
        _buildBalancesSection(state, isDark),
        const Gap(24),

        // === SETTLEMENTS ===
        _buildSettlementsSection(state, isDark),
      ],
    );
  }

  Widget _buildStatusBanner(SettlementState state, bool isDark) {
    final isAllSettled = state.isSettled;

    return Card(
      color:
          isAllSettled
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.primary.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              isAllSettled
                  ? Icons.check_circle_rounded
                  : Icons.account_balance_wallet_rounded,
              size: 48,
              color: isAllSettled ? AppColors.success : AppColors.primary,
            ),
            const Gap(12),
            Text(
              isAllSettled ? 'All Settled!' : 'Settlement Required',
              style: AppTextStyles.h3.copyWith(
                color: isAllSettled ? AppColors.success : AppColors.primary,
              ),
            ),
            const Gap(4),
            Text(
              isAllSettled
                  ? 'Everyone is even — no payments needed'
                  : '${state.settlements.length} transaction${state.settlements.length == 1 ? '' : 's'} to settle all debts',
              style: AppTextStyles.bodyMedium.copyWith(
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isAllSettled) ...[
              const Gap(8),
              Text(
                'Total: ${AppConstants.currency}${state.totalToSettle.toStringAsFixed(2)}',
                style: AppTextStyles.amountSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBalancesSection(SettlementState state, bool isDark) {
    // Sort balances: largest positive first, then largest negative
    final sortedBalances =
        state.netBalances.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Net Balances',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(4),
        Text(
          'How much each person is owed or owes overall',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const Gap(12),
        ...sortedBalances.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BalanceCard(memberName: entry.key, netBalance: entry.value),
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementsSection(SettlementState state, bool isDark) {
    if (state.isSettled) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payments to Make',
          style: AppTextStyles.h3.copyWith(
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const Gap(4),
        Text(
          'Minimum transactions to settle all debts',
          style: AppTextStyles.bodySmall.copyWith(
            color:
                isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
          ),
        ),
        const Gap(12),
        ...state.settlements.map(
          (settlement) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SettlementCard(settlement: settlement),
          ),
        ),
      ],
    );
  }
}
