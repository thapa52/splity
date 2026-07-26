import '../repositories/expense_repository.dart';

/// Deletes an expense by its unique ID.
///
/// Business rules:
/// - Expense ID cannot be empty
/// - Deletion is permanent — no undo
///
/// Note: Deleting an expense changes the group balances.
/// The balance summary will be recalculated automatically
/// since it is derived from the remaining expenses.
class DeleteExpense {
  final ExpenseRepository _repository;

  const DeleteExpense(this._repository);

  Future<void> call(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('Expense ID cannot be empty');
    }

    await _repository.deleteExpense(id);
  }
}
