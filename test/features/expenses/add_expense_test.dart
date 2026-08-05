import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:splity/features/expenses/domain/entities/expense.dart';
import 'package:splity/features/expenses/domain/entities/expense_split.dart';
import 'package:splity/features/expenses/domain/usecases/add_expense.dart';
import '../../helpers/test_helpers.dart';

void main() {
  late AddExpense addExpense;
  late MockExpenseRepository mockRepository;

  setUpAll(() {
    registerFallbackValues();
  });

  setUp(() {
    mockRepository = MockExpenseRepository();
    addExpense = AddExpense(mockRepository);

    // Default stub
    when(() => mockRepository.addExpense(any())).thenAnswer((invocation) async {
      return invocation.positionalArguments[0] as Expense;
    });
  });

  // ================================================================
  // VALID EXPENSE CREATION
  // ================================================================
  group('Valid Expense Creation', () {
    test('should add expense with valid data', () async {
      final expense = createTestExpense();

      final result = await addExpense(expense);

      expect(result.title, 'Test Expense');
      expect(result.amount, 300.0);
      verify(() => mockRepository.addExpense(any())).called(1);
    });

    test('should trim whitespace from title', () async {
      final expense = createTestExpense(title: '  Dinner  ');

      final result = await addExpense(expense);

      expect(result.title, 'Dinner');
    });

    test('should trim whitespace from description', () async {
      final expense = createTestExpense(description: '  Friday dinner  ');

      final result = await addExpense(expense);

      expect(result.description, 'Friday dinner');
    });

    test('should accept expense with single split', () async {
      final expense = createTestExpense(
        amount: 100,
        splits: [const ExpenseSplit(memberName: 'Alice', amount: 100)],
      );

      final result = await addExpense(expense);

      expect(result.splits.length, 1);
    });

    test('should accept expense with many splits', () async {
      final expense = createTestExpense(
        amount: 500,
        splits: [
          const ExpenseSplit(memberName: 'Alice', amount: 100),
          const ExpenseSplit(memberName: 'Bob', amount: 100),
          const ExpenseSplit(memberName: 'Carol', amount: 100),
          const ExpenseSplit(memberName: 'Dave', amount: 100),
          const ExpenseSplit(memberName: 'Eve', amount: 100),
        ],
      );

      final result = await addExpense(expense);

      expect(result.splits.length, 5);
    });
  });

  // ================================================================
  // VALIDATION — TITLE
  // ================================================================
  group('Validation — Title', () {
    test('should throw ArgumentError when title is empty', () async {
      final expense = createTestExpense(title: '');

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });

    test('should throw ArgumentError when title is only whitespace', () async {
      final expense = createTestExpense(title: '   ');

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });
  });

  // ================================================================
  // VALIDATION — AMOUNT
  // ================================================================
  group('Validation — Amount', () {
    test('should throw ArgumentError when amount is zero', () async {
      final expense = createTestExpense(
        amount: 0,
        splits: [const ExpenseSplit(memberName: 'Alice', amount: 0)],
      );

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
    });

    test('should throw ArgumentError when amount is negative', () async {
      final expense = createTestExpense(
        amount: -100,
        splits: [const ExpenseSplit(memberName: 'Alice', amount: -100)],
      );

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
    });

    test('should accept decimal amounts', () async {
      final expense = createTestExpense(
        amount: 99.99,
        splits: [
          const ExpenseSplit(memberName: 'Alice', amount: 50.00),
          const ExpenseSplit(memberName: 'Bob', amount: 49.99),
        ],
      );

      final result = await addExpense(expense);

      expect(result.amount, 99.99);
    });
  });

  // ================================================================
  // VALIDATION — PAID BY
  // ================================================================
  group('Validation — Paid By', () {
    test('should throw ArgumentError when paidBy is empty', () async {
      final expense = createTestExpense(paidBy: '');

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });

    test('should throw ArgumentError when paidBy is only whitespace', () async {
      final expense = createTestExpense(paidBy: '   ');

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });
  });

  // ================================================================
  // VALIDATION — SPLITS
  // ================================================================
  group('Validation — Splits', () {
    test('should throw ArgumentError when splits are empty', () async {
      final expense = createTestExpense(splits: []);

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });

    test('should throw ArgumentError when split amount is negative', () async {
      final expense = createTestExpense(
        amount: 100,
        splits: [
          const ExpenseSplit(memberName: 'Alice', amount: 150),
          const ExpenseSplit(memberName: 'Bob', amount: -50),
        ],
      );

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
      verifyNever(() => mockRepository.addExpense(any()));
    });

    test(
      'should throw ArgumentError when splits do not sum to total',
      () async {
        final expense = createTestExpense(
          amount: 300,
          splits: [
            const ExpenseSplit(memberName: 'Alice', amount: 100),
            const ExpenseSplit(memberName: 'Bob', amount: 100),
            // Missing Carol's 100 — sum is 200 not 300
          ],
        );

        expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
        verifyNever(() => mockRepository.addExpense(any()));
      },
    );

    test('should accept splits within 0.01 tolerance', () async {
      // 100 / 3 = 33.33 * 3 = 99.99 — within tolerance
      final expense = createTestExpense(
        amount: 100,
        splits: [
          const ExpenseSplit(memberName: 'Alice', amount: 33.34),
          const ExpenseSplit(memberName: 'Bob', amount: 33.33),
          const ExpenseSplit(memberName: 'Carol', amount: 33.33),
        ],
      );

      final result = await addExpense(expense);

      expect(result.splits.length, 3);
    });

    test('should throw ArgumentError when splits exceed tolerance', () async {
      final expense = createTestExpense(
        amount: 100,
        splits: [
          const ExpenseSplit(memberName: 'Alice', amount: 60),
          const ExpenseSplit(memberName: 'Bob', amount: 60),
          // Sum is 120 — exceeds 100 by more than 0.01
        ],
      );

      expect(() => addExpense(expense), throwsA(isA<ArgumentError>()));
    });
  });

  // ================================================================
  // REPOSITORY INTERACTION
  // ================================================================
  group('Repository Interaction', () {
    test('should call repository exactly once on success', () async {
      final expense = createTestExpense();

      await addExpense(expense);

      verify(() => mockRepository.addExpense(any())).called(1);
    });

    test('should not call repository when validation fails', () async {
      final expense = createTestExpense(title: '');

      try {
        await addExpense(expense);
      } catch (_) {}

      verifyNever(() => mockRepository.addExpense(any()));
    });

    test('should propagate repository exceptions', () async {
      when(
        () => mockRepository.addExpense(any()),
      ).thenThrow(Exception('Storage error'));

      final expense = createTestExpense();

      expect(() => addExpense(expense), throwsA(isA<Exception>()));
    });
  });
}
