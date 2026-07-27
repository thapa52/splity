import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../expenses/presentation/providers/expense_provider.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/usecases/calculate_settlements.dart';

part 'settlement_provider.g.dart';

// ===================================================================
// STATE
// ===================================================================

/// Represents the UI state for the settlement feature.
class SettlementState {
  final List<Settlement> settlements;
  final Map<String, double> netBalances;
  final bool isLoading;
  final String? errorMessage;

  const SettlementState({
    this.settlements = const [],
    this.netBalances = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  SettlementState copyWith({
    List<Settlement>? settlements,
    Map<String, double>? netBalances,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettlementState(
      settlements: settlements ?? this.settlements,
      netBalances: netBalances ?? this.netBalances,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get isSettled => settlements.isEmpty;
  bool get hasError => errorMessage != null;

  /// Total amount that needs to be settled
  double get totalToSettle => settlements.fold(0, (sum, s) => sum + s.amount);
}

// ===================================================================
// USE CASE PROVIDER
// ===================================================================

/// Provides the [CalculateSettlements] use case.
@riverpod
CalculateSettlements calculateSettlementsUseCase(Ref ref) {
  return const CalculateSettlements();
}

// ===================================================================
// NOTIFIER
// ===================================================================

/// Manages settlement state for a specific group.
///
/// Watches the expense state and recalculates settlements
/// automatically whenever expenses change.
@riverpod
class SettlementNotifier extends _$SettlementNotifier {
  @override
  SettlementState build(String groupId) {
    // Watch expense state — recalculates when expenses change
    final expenseState = ref.watch(expenseNotifierProvider(groupId));

    if (expenseState.isLoading) {
      return const SettlementState(isLoading: true);
    }

    if (expenseState.hasError) {
      return SettlementState(errorMessage: expenseState.errorMessage);
    }

    return _calculate(expenseState.expenses);
  }

  /// Calculates settlements from the current expense list.
  SettlementState _calculate(expenses) {
    try {
      final useCase = ref.read(calculateSettlementsUseCaseProvider);
      final settlements = useCase(expenses);
      final netBalances = useCase.getNetBalances(expenses);

      return SettlementState(
        settlements: settlements,
        netBalances: netBalances,
        isLoading: false,
      );
    } catch (e) {
      return SettlementState(
        errorMessage: 'Failed to calculate settlements: $e',
      );
    }
  }
}
