import 'package:freezed_annotation/freezed_annotation.dart';

import 'expense_split.dart';

part 'expense.freezed.dart';

/// Core business entity representing an expense in a group.
///
/// Every expense belongs to one group and records:
/// - who paid
/// - total amount
/// - category/title/description
/// - how the amount is split among members
///
/// Example:
/// - Title: Dinner
/// - Amount: 900
/// - Paid by: Alice
/// - Splits:
///   - Alice: 300
///   - Bob: 300
///   - Carol: 300
@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String groupId,
    required String title,
    required double amount,
    required String category,
    required String paidBy,
    required List<ExpenseSplit> splits,
    required DateTime createdAt,
    @Default('') String description,
  }) = _Expense;
}
