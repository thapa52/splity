import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/expense_split.dart';

part 'expense_split_model.g.dart';

/// Hive model for persisting [ExpenseSplit] data locally.
///
/// Stored as a nested object inside [ExpenseModel].
/// Each split records how much one member owes for an expense.
@HiveType(typeId: 2)
class ExpenseSplitModel extends HiveObject {
  @HiveField(0)
  final String memberName;

  @HiveField(1)
  final double amount;

  ExpenseSplitModel({required this.memberName, required this.amount});

  /// Converts a domain [ExpenseSplit] entity to a [ExpenseSplitModel].
  factory ExpenseSplitModel.fromEntity(ExpenseSplit split) {
    return ExpenseSplitModel(
      memberName: split.memberName,
      amount: split.amount,
    );
  }

  /// Converts this [ExpenseSplitModel] to a domain [ExpenseSplit] entity.
  ExpenseSplit toEntity() {
    return ExpenseSplit(memberName: memberName, amount: amount);
  }
}
