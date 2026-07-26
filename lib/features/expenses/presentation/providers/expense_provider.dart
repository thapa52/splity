import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/expense_local_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses_by_group.dart';

part 'expense_provider.g.dart';

// ===================================================================
// STATE
// ===================================================================

/// Represents the UI state for the expenses feature.
class ExpenseState {
  final List<Expense> expenses;
  final bool isLoading;
  final String? errorMessage;

  const ExpenseState({
    this.expenses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  bool get hasExpenses => expenses.isNotEmpty;
  bool get hasError => errorMessage != null;

  /// Total amount of all expenses
  double get totalAmount =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);
}

// ===================================================================
// DEPENDENCY PROVIDERS
// ===================================================================

/// Provides the [ExpenseLocalDatasource] implementation.
@riverpod
ExpenseLocalDatasource expenseLocalDatasource(Ref ref) {
  return ExpenseLocalDatasourceImpl();
}

/// Provides the [ExpenseRepositoryImpl].
@riverpod
ExpenseRepositoryImpl expenseRepository(Ref ref) {
  final datasource = ref.watch(expenseLocalDatasourceProvider);
  return ExpenseRepositoryImpl(datasource);
}

// ===================================================================
// USE CASE PROVIDERS
// ===================================================================

/// Provides the [GetExpensesByGroup] use case.
@riverpod
GetExpensesByGroup getExpensesByGroup(Ref ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return GetExpensesByGroup(repository);
}

/// Provides the [AddExpense] use case.
@riverpod
AddExpense addExpense(Ref ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return AddExpense(repository);
}

/// Provides the [DeleteExpense] use case.
@riverpod
DeleteExpense deleteExpense(Ref ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return DeleteExpense(repository);
}

// ===================================================================
// NOTIFIER
// ===================================================================

/// Manages the state for the expenses feature.
///
/// Takes a [groupId] parameter so it loads expenses
/// for a specific group only.
@riverpod
class ExpenseNotifier extends _$ExpenseNotifier {
  @override
  ExpenseState build(String groupId) {
    Future.microtask(() => _loadExpenses());
    return const ExpenseState(isLoading: true);
  }

  /// Loads all expenses for the current group.
  Future<void> _loadExpenses() async {
    try {
      final useCase = ref.read(getExpensesByGroupProvider);
      final expenses = await useCase(groupId);
      state = state.copyWith(
        expenses: expenses,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load expenses. Please try again.',
      );
    }
  }

  /// Refreshes the expenses list.
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _loadExpenses();
  }

  /// Adds a new expense to the group.
  ///
  /// Returns `true` if successful, `false` if failed.
  Future<bool> addNewExpense(Expense expense) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(addExpenseProvider);
      await useCase(expense);
      await _loadExpenses();
      return true;
    } on ArgumentError catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add expense. Please try again.',
      );
      return false;
    }
  }

  /// Removes an expense by its [id].
  ///
  /// Returns `true` if successful, `false` if failed.
  Future<bool> removeExpense(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(deleteExpenseProvider);
      await useCase(id);
      await _loadExpenses();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete expense. Please try again.',
      );
      return false;
    }
  }
}
