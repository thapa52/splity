import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

/// Adds a new expense to a group with validation.
///
/// Business rules:
/// - Title cannot be empty
/// - Amount must be greater than zero
/// - PaidBy must be a valid member name
/// - Splits must not be empty
/// - Sum of splits must equal total amount
/// - All split amounts must be non-negative
class AddExpense {
  final ExpenseRepository _repository;

  const AddExpense(this._repository);

  Future<Expense> call(Expense expense) async {
    // Validate title
    if (expense.title.trim().isEmpty) {
      throw ArgumentError('Expense title cannot be empty');
    }

    // Validate amount
    if (expense.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero');
    }

    // Validate paidBy
    if (expense.paidBy.trim().isEmpty) {
      throw ArgumentError('Paid by cannot be empty');
    }

    // Validate splits exist
    if (expense.splits.isEmpty) {
      throw ArgumentError('Expense must have at least one split');
    }

    // Validate no negative split amounts
    for (final split in expense.splits) {
      if (split.amount < 0) {
        throw ArgumentError(
          '${split.memberName} cannot have a negative split amount',
        );
      }
    }

    // Validate splits sum equals total amount
    final splitsSum = expense.splits.fold<double>(
      0,
      (sum, split) => sum + split.amount,
    );

    // Allow tiny floating point difference (0.01)
    final difference = (splitsSum - expense.amount).abs();
    if (difference > 0.01) {
      throw ArgumentError(
        'Split amounts (${splitsSum.toStringAsFixed(2)}) '
        'must equal total amount (${expense.amount.toStringAsFixed(2)})',
      );
    }

    // Clean up title and description
    final cleanedExpense = expense.copyWith(
      title: expense.title.trim(),
      description: expense.description.trim(),
    );

    return _repository.addExpense(cleanedExpense);
  }
}
