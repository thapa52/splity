import 'package:mocktail/mocktail.dart';
import 'package:splity/features/expenses/domain/entities/expense.dart';
import 'package:splity/features/expenses/domain/entities/expense_split.dart';
import 'package:splity/features/expenses/domain/repositories/expense_repository.dart';
import 'package:splity/features/groups/domain/entities/group.dart';
import 'package:splity/features/groups/domain/repositories/group_repository.dart';

// ===================================================================
// MOCK REPOSITORIES
// ===================================================================

/// Mock implementation of [GroupRepository] for testing.
class MockGroupRepository extends Mock implements GroupRepository {}

/// Mock implementation of [ExpenseRepository] for testing.
class MockExpenseRepository extends Mock implements ExpenseRepository {}

// ===================================================================
// FAKES — Required by mocktail for registerFallbackValue
// ===================================================================

class FakeGroup extends Fake implements Group {}

class FakeExpense extends Fake implements Expense {}

class FakeExpenseSplit extends Fake implements ExpenseSplit {}

// ===================================================================
// REGISTER FALLBACKS — Call this in setUpAll in every test file
// ===================================================================

/// Must be called in setUpAll() before using any() with custom types.
///
/// ```dart
/// setUpAll(() {
///   registerFallbackValues();
/// });
/// ```
void registerFallbackValues() {
  registerFallbackValue(FakeGroup());
  registerFallbackValue(FakeExpense());
  registerFallbackValue(FakeExpenseSplit());
}

// ===================================================================
// TEST DATA FACTORIES
// ===================================================================

/// Creates a test [Group] with sensible defaults.
Group createTestGroup({
  String id = 'test-group-id',
  String name = 'Test Group',
  List<String>? members,
  String description = '',
  String emoji = '👥',
}) {
  return Group(
    id: id,
    name: name,
    members: members ?? ['Alice', 'Bob', 'Carol'],
    description: description,
    emoji: emoji,
    createdAt: DateTime(2026, 1, 1),
  );
}

/// Creates a test [Expense] with sensible defaults.
Expense createTestExpense({
  String id = 'test-expense-id',
  String groupId = 'test-group-id',
  String title = 'Test Expense',
  double amount = 300.0,
  String category = 'Food',
  String paidBy = 'Alice',
  List<ExpenseSplit>? splits,
  String description = '',
}) {
  return Expense(
    id: id,
    groupId: groupId,
    title: title,
    amount: amount,
    category: category,
    paidBy: paidBy,
    splits:
        splits ??
        [
          const ExpenseSplit(memberName: 'Alice', amount: 100),
          const ExpenseSplit(memberName: 'Bob', amount: 100),
          const ExpenseSplit(memberName: 'Carol', amount: 100),
        ],
    createdAt: DateTime(2026, 1, 1),
    description: description,
  );
}

/// Creates a list of equal splits for a given amount and members.
List<ExpenseSplit> createEqualSplits({
  required List<String> members,
  required double totalAmount,
}) {
  final perPerson = double.parse(
    (totalAmount / members.length).toStringAsFixed(2),
  );
  return members
      .map((m) => ExpenseSplit(memberName: m, amount: perPerson))
      .toList();
}
