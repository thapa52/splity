import 'package:flutter_test/flutter_test.dart';
import 'package:splity/features/expenses/domain/entities/expense.dart';
import 'package:splity/features/expenses/domain/entities/expense_split.dart';
import 'package:splity/features/settlement/domain/usecases/calculate_settlements.dart';

void main() {
  late CalculateSettlements calculateSettlements;

  setUp(() {
    calculateSettlements = const CalculateSettlements();
  });

  // ================================================================
  // HELPER — creates an expense quickly for tests
  // ================================================================
  Expense createExpense({
    required String paidBy,
    required double amount,
    required List<ExpenseSplit> splits,
    String groupId = 'test-group',
  }) {
    return Expense(
      id: 'expense-${DateTime.now().microsecondsSinceEpoch}',
      groupId: groupId,
      title: 'Test Expense',
      amount: amount,
      category: 'Other',
      paidBy: paidBy,
      splits: splits,
      createdAt: DateTime.now(),
    );
  }

  // ================================================================
  // TEST GROUP 1: Edge Cases
  // ================================================================
  group('Edge Cases', () {
    test('should return empty list when no expenses', () {
      final result = calculateSettlements([]);
      expect(result, isEmpty);
    });

    test('should return empty list when one person pays and owes equally', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 100,
          splits: [const ExpenseSplit(memberName: 'Alice', amount: 100)],
        ),
      ];

      final result = calculateSettlements(expenses);
      expect(result, isEmpty);
    });

    test('should return empty list when all balances are zero', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 100,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 50),
            const ExpenseSplit(memberName: 'Bob', amount: 50),
          ],
        ),
        createExpense(
          paidBy: 'Bob',
          amount: 100,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 50),
            const ExpenseSplit(memberName: 'Bob', amount: 50),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);
      expect(result, isEmpty);
    });
  });

  // ================================================================
  // TEST GROUP 2: Simple Two-Person Splits
  // ================================================================
  group('Two-Person Splits', () {
    test('should handle simple two-person equal split', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 100,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 50),
            const ExpenseSplit(memberName: 'Bob', amount: 50),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      expect(result.length, 1);
      expect(result.first.fromMember, 'Bob');
      expect(result.first.toMember, 'Alice');
      expect(result.first.amount, 50.0);
    });

    test('should handle two people with multiple expenses', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 200,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 100),
            const ExpenseSplit(memberName: 'Bob', amount: 100),
          ],
        ),
        createExpense(
          paidBy: 'Bob',
          amount: 60,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 30),
            const ExpenseSplit(memberName: 'Bob', amount: 30),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: +200 - 100 - 30 = +70
      // Bob net: +60 - 100 - 30 = -70
      expect(result.length, 1);
      expect(result.first.fromMember, 'Bob');
      expect(result.first.toMember, 'Alice');
      expect(result.first.amount, 70.0);
    });
  });

  // ================================================================
  // TEST GROUP 3: Three-Person Splits
  // ================================================================
  group('Three-Person Splits', () {
    test('should handle three-person equal split', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 900,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 300),
            const ExpenseSplit(memberName: 'Bob', amount: 300),
            const ExpenseSplit(memberName: 'Carol', amount: 300),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: +900 - 300 = +600
      // Bob net: -300
      // Carol net: -300
      expect(result.length, 2);

      final totalSettled = result.fold<double>(0, (sum, s) => sum + s.amount);
      expect(totalSettled, 600.0);

      // All settlements should go to Alice
      for (final settlement in result) {
        expect(settlement.toMember, 'Alice');
      }
    });

    test('should minimize transactions for three-person chain debt', () {
      // Alice owes Bob ₹100, Bob owes Carol ₹100
      // Optimal: Alice pays Carol ₹100 directly (1 transaction)
      final expenses = [
        createExpense(
          paidBy: 'Bob',
          amount: 200,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 100),
            const ExpenseSplit(memberName: 'Bob', amount: 100),
          ],
        ),
        createExpense(
          paidBy: 'Carol',
          amount: 200,
          splits: [
            const ExpenseSplit(memberName: 'Bob', amount: 100),
            const ExpenseSplit(memberName: 'Carol', amount: 100),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Bob net: +200 - 100 - 100 = 0
      // Alice net: -100
      // Carol net: +200 - 100 = +100
      // Only Alice → Carol: ₹100
      expect(result.length, 1);
      expect(result.first.fromMember, 'Alice');
      expect(result.first.toMember, 'Carol');
      expect(result.first.amount, 100.0);
    });
  });

  // ================================================================
  // TEST GROUP 4: Complex Multi-Person
  // ================================================================
  group('Complex Multi-Person', () {
    test('should handle four people with multiple expenses', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 600,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 150),
            const ExpenseSplit(memberName: 'Bob', amount: 150),
            const ExpenseSplit(memberName: 'Carol', amount: 150),
            const ExpenseSplit(memberName: 'Dave', amount: 150),
          ],
        ),
        createExpense(
          paidBy: 'Bob',
          amount: 300,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 75),
            const ExpenseSplit(memberName: 'Bob', amount: 75),
            const ExpenseSplit(memberName: 'Carol', amount: 75),
            const ExpenseSplit(memberName: 'Dave', amount: 75),
          ],
        ),
        createExpense(
          paidBy: 'Carol',
          amount: 240,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 60),
            const ExpenseSplit(memberName: 'Bob', amount: 60),
            const ExpenseSplit(memberName: 'Carol', amount: 60),
            const ExpenseSplit(memberName: 'Dave', amount: 60),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: +600 - 150 - 75 - 60 = +315
      // Bob net: +300 - 150 - 75 - 60 = +15
      // Carol net: +240 - 150 - 75 - 60 = -45
      // Dave net: 0 - 150 - 75 - 60 = -285

      // Verify total money in = total money out
      final totalFrom = result.fold<double>(0, (s, t) => s + t.amount);
      expect(totalFrom, closeTo(330, 0.01)); // 315 + 15 = 330

      // Verify we have fewer transactions than the naive approach
      // Naive would need up to 6 transactions
      expect(result.length, lessThanOrEqualTo(3));
    });

    test('should handle five people correctly', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 500,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 100),
            const ExpenseSplit(memberName: 'Bob', amount: 100),
            const ExpenseSplit(memberName: 'Carol', amount: 100),
            const ExpenseSplit(memberName: 'Dave', amount: 100),
            const ExpenseSplit(memberName: 'Eve', amount: 100),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: +400
      // Bob, Carol, Dave, Eve: -100 each
      expect(result.length, 4);

      final totalSettled = result.fold<double>(0, (s, t) => s + t.amount);
      expect(totalSettled, 400.0);

      for (final settlement in result) {
        expect(settlement.toMember, 'Alice');
        expect(settlement.amount, 100.0);
      }
    });
  });

  // ================================================================
  // TEST GROUP 5: Decimal and Rounding
  // ================================================================
  group('Decimal and Rounding', () {
    test('should handle amounts with decimals', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 99.99,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 33.33),
            const ExpenseSplit(memberName: 'Bob', amount: 33.33),
            const ExpenseSplit(memberName: 'Carol', amount: 33.33),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: 99.99 - 33.33 = 66.66
      // Bob net: -33.33
      // Carol net: -33.33
      expect(result.length, 2);

      final totalSettled = result.fold<double>(0, (s, t) => s + t.amount);
      expect(totalSettled, closeTo(66.66, 0.01));
    });

    test('should handle unequal splits with decimals', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 100,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 40),
            const ExpenseSplit(memberName: 'Bob', amount: 35.50),
            const ExpenseSplit(memberName: 'Carol', amount: 24.50),
          ],
        ),
      ];

      final result = calculateSettlements(expenses);

      // Alice net: 100 - 40 = +60
      // Bob net: -35.50
      // Carol net: -24.50
      expect(result.length, 2);
      expect(
        result.fold<double>(0, (s, t) => s + t.amount),
        closeTo(60.0, 0.01),
      );
    });
  });

  // ================================================================
  // TEST GROUP 6: Net Balance Calculation
  // ================================================================
  group('Net Balance Calculation', () {
    test('should calculate correct net balances', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 300,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 100),
            const ExpenseSplit(memberName: 'Bob', amount: 100),
            const ExpenseSplit(memberName: 'Carol', amount: 100),
          ],
        ),
      ];

      final balances = calculateSettlements.getNetBalances(expenses);

      expect(balances['Alice'], 200.0);
      expect(balances['Bob'], -100.0);
      expect(balances['Carol'], -100.0);
    });

    test('should return empty map for no expenses', () {
      final balances = calculateSettlements.getNetBalances([]);
      expect(balances, isEmpty);
    });

    test('should handle multiple expenses in balance calculation', () {
      final expenses = [
        createExpense(
          paidBy: 'Alice',
          amount: 100,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 50),
            const ExpenseSplit(memberName: 'Bob', amount: 50),
          ],
        ),
        createExpense(
          paidBy: 'Bob',
          amount: 80,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 40),
            const ExpenseSplit(memberName: 'Bob', amount: 40),
          ],
        ),
      ];

      final balances = calculateSettlements.getNetBalances(expenses);

      // Alice: +100 - 50 - 40 = +10
      // Bob: +80 - 50 - 40 = -10
      expect(balances['Alice'], 10.0);
      expect(balances['Bob'], -10.0);
    });
  });
}
