import '../../../expenses/domain/entities/expense.dart';
import '../entities/settlement.dart';

/// Calculates the minimum number of transactions needed
/// to settle all debts within a group.
///
/// Algorithm:
/// 1. Calculate net balance for each member
///    (net = total paid - total owed)
/// 2. Separate into creditors (net > 0) and debtors (net < 0)
/// 3. Sort both lists by amount (largest first)
/// 4. Greedily match largest debtor with largest creditor
/// 5. Repeat until all balances are zero
///
/// This greedy approach minimizes the number of transactions
/// in most practical cases.
///
/// Example:
/// ```
/// Alice paid ₹600 dinner (split 3 ways: ₹200 each)
/// Bob paid ₹300 transport (split 3 ways: ₹100 each)
///
/// Net balances:
///   Alice: +₹400 (paid 600, owes 100 to Bob)
///   Bob:   +₹100 (paid 300, owes 200 to Alice)
///   Carol: -₹300 (paid 0, owes 200 + 100)
///   Dave:  -₹200 (paid 0, owes 200 + 100... wait, not in this example)
///
/// Settlements:
///   Carol → Alice: ₹300  (1 transaction instead of 2)
/// ```
class CalculateSettlements {
  const CalculateSettlements();

  /// Main entry point.
  ///
  /// Takes a list of expenses and returns the minimum
  /// list of settlements needed to clear all debts.
  List<Settlement> call(List<Expense> expenses) {
    if (expenses.isEmpty) return [];

    // Step 1: Calculate net balances
    final balances = _calculateNetBalances(expenses);

    // Step 2: Generate minimum settlements
    return _minimizeTransactions(balances);
  }

  /// Calculates net balance for each member.
  ///
  /// Net balance = total amount paid - total amount owed
  ///
  /// Positive balance → person is owed money (creditor)
  /// Negative balance → person owes money (debtor)
  /// Zero balance → person is settled
  Map<String, double> _calculateNetBalances(List<Expense> expenses) {
    final balances = <String, double>{};

    for (final expense in expenses) {
      // The payer gets credited the full amount
      balances[expense.paidBy] =
          (balances[expense.paidBy] ?? 0) + expense.amount;

      // Each split member gets debited their share
      for (final split in expense.splits) {
        balances[split.memberName] =
            (balances[split.memberName] ?? 0) - split.amount;
      }
    }

    // Round all balances to 2 decimal places
    return balances.map(
      (key, value) => MapEntry(key, double.parse(value.toStringAsFixed(2))),
    );
  }

  /// Minimizes the number of transactions using a greedy approach.
  ///
  /// Separates people into creditors and debtors, then
  /// greedily matches the largest debtor with the largest creditor.
  List<Settlement> _minimizeTransactions(Map<String, double> balances) {
    final settlements = <Settlement>[];

    // Separate into creditors and debtors
    // Filter out anyone with zero balance (already settled)
    final creditors = <MapEntry<String, double>>[];
    final debtors = <MapEntry<String, double>>[];

    for (final entry in balances.entries) {
      if (entry.value > 0.01) {
        creditors.add(entry);
      } else if (entry.value < -0.01) {
        debtors.add(entry);
      }
      // Skip zero balances — they're settled
    }

    // Sort: largest amounts first
    creditors.sort((a, b) => b.value.compareTo(a.value));
    debtors.sort((a, b) => a.value.compareTo(b.value)); // most negative first

    // Make mutable copies of amounts
    final creditAmounts = {for (final c in creditors) c.key: c.value};
    final debtAmounts = {for (final d in debtors) d.key: d.value.abs()};

    // Greedy matching
    while (creditAmounts.isNotEmpty && debtAmounts.isNotEmpty) {
      // Find largest creditor and largest debtor
      final creditor = creditAmounts.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );
      final debtor = debtAmounts.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );

      // Settlement amount is the minimum of what's owed and what's due
      final amount =
          creditor.value < debtor.value ? creditor.value : debtor.value;

      // Round to 2 decimal places
      final roundedAmount = double.parse(amount.toStringAsFixed(2));

      if (roundedAmount > 0.01) {
        settlements.add(
          Settlement(
            fromMember: debtor.key,
            toMember: creditor.key,
            amount: roundedAmount,
          ),
        );
      }

      // Reduce balances
      creditAmounts[creditor.key] = double.parse(
        (creditor.value - roundedAmount).toStringAsFixed(2),
      );
      debtAmounts[debtor.key] = double.parse(
        (debtor.value - roundedAmount).toStringAsFixed(2),
      );

      // Remove settled people
      if (creditAmounts[creditor.key]! < 0.01) {
        creditAmounts.remove(creditor.key);
      }
      if (debtAmounts[debtor.key]! < 0.01) {
        debtAmounts.remove(debtor.key);
      }
    }

    return settlements;
  }

  /// Public method to get net balances for display purposes.
  ///
  /// Used by the balance summary screen to show each
  /// member's net position (owes or is owed).
  Map<String, double> getNetBalances(List<Expense> expenses) {
    if (expenses.isEmpty) return {};
    return _calculateNetBalances(expenses);
  }
}
