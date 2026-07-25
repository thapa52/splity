import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/expense.dart';
import 'expense_split_model.dart';

part 'expense_model.g.dart';

/// Hive model for persisting [Expense] data locally.
///
/// Contains a list of [ExpenseSplitModel] for split details.
///
/// Conversion flow:
/// Hive storage → [ExpenseModel] → [Expense] entity → UI
/// UI → [Expense] entity → [ExpenseModel] → Hive storage
@HiveType(typeId: 1)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String groupId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String paidBy;

  @HiveField(6)
  final List<ExpenseSplitModel> splits;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String description;

  ExpenseModel({
    required this.id,
    required this.groupId,
    required this.title,
    required this.amount,
    required this.category,
    required this.paidBy,
    required this.splits,
    required this.createdAt,
    required this.description,
  });

  /// Converts a domain [Expense] entity to an [ExpenseModel].
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      groupId: expense.groupId,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      paidBy: expense.paidBy,
      splits:
          expense.splits.map((s) => ExpenseSplitModel.fromEntity(s)).toList(),
      createdAt: expense.createdAt,
      description: expense.description,
    );
  }

  /// Converts this [ExpenseModel] to a domain [Expense] entity.
  Expense toEntity() {
    return Expense(
      id: id,
      groupId: groupId,
      title: title,
      amount: amount,
      category: category,
      paidBy: paidBy,
      splits: splits.map((s) => s.toEntity()).toList(),
      createdAt: createdAt,
      description: description,
    );
  }
}
