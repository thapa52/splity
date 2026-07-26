import '../entities/expense.dart';

/// Abstract contract for expense data operations.
///
/// The domain layer defines what it needs through this interface.
/// The data layer will implement it using Hive.
///
/// This keeps the domain independent from storage details.
abstract class ExpenseRepository {
  /// Adds a new expense to storage.
  Future<Expense> addExpense(Expense expense);

  /// Returns all expenses for a given [groupId].
  ///
  /// Should be sorted by creation date (newest first).
  Future<List<Expense>> getExpensesByGroup(String groupId);

  /// Returns a single expense by its [id].
  ///
  /// Returns `null` if not found.
  Future<Expense?> getExpenseById(String id);

  /// Updates an existing expense.
  Future<Expense> updateExpense(Expense expense);

  /// Deletes an expense by its [id].
  Future<void> deleteExpense(String id);
}
