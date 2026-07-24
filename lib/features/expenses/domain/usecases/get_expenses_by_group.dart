import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Retrieves all expenses for a specific group.
///
/// Returns expenses sorted by creation date (newest first).
/// Returns an empty list if no expenses exist for the group.
class GetExpensesByGroup {
  final ExpenseRepository _repository;

  const GetExpensesByGroup(this._repository);

  Future<List<Expense>> call(String groupId) async {
    if (groupId.trim().isEmpty) {
      throw ArgumentError('Group ID cannot be empty');
    }

    return _repository.getExpensesByGroup(groupId);
  }
}
