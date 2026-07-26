import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_split.freezed.dart';

/// Represents how much one member owes for a specific expense.
///
/// Every expense has a list of [ExpenseSplit] objects —
/// one per member — that together sum to the total expense amount.
///
/// Example for a ₹900 dinner split equally among 3:
/// ```
/// ExpenseSplit(memberName: 'Alice', amount: 300.00)
/// ExpenseSplit(memberName: 'Bob',   amount: 300.00)
/// ExpenseSplit(memberName: 'Carol', amount: 300.00)
/// ```
@freezed
abstract class ExpenseSplit with _$ExpenseSplit {
  const factory ExpenseSplit({
    required String memberName,
    required double amount,
  }) = _ExpenseSplit;
}
