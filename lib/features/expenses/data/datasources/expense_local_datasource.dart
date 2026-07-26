import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/expense_model.dart';

/// Interface for expense local storage operations.
///
/// Defines the contract for Hive operations.
/// Makes it easy to create a fake for testing.
abstract class ExpenseLocalDatasource {
  Future<List<ExpenseModel>> getExpensesByGroup(String groupId);
  Future<ExpenseModel?> getExpenseById(String id);
  Future<void> saveExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
}

/// Hive implementation of [ExpenseLocalDatasource].
///
/// All Hive-specific code for expenses lives here.
/// Uses the expense's [id] as the Hive box key for O(1) lookups.
class ExpenseLocalDatasourceImpl implements ExpenseLocalDatasource {
  /// Returns the Hive box for expenses.
  Box<ExpenseModel> get _box =>
      Hive.box<ExpenseModel>(AppConstants.expensesBox);

  @override
  Future<List<ExpenseModel>> getExpensesByGroup(String groupId) async {
    final allExpenses = _box.values.toList();

    // Filter by groupId
    final groupExpenses =
        allExpenses.where((expense) => expense.groupId == groupId).toList();

    // Sort by creation date — newest first
    groupExpenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return groupExpenses;
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> saveExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }
}
