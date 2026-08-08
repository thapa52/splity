import '../constants/app_constants.dart';

/// Utility for formatting currency amounts consistently.
///
/// Used across all screens to display monetary values
/// in a consistent format.
abstract final class CurrencyFormatter {
  /// Formats a double as a currency string.
  ///
  /// Example: 1234.5 → ₹1,234.50
  static String format(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();

    final parts = absAmount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Add comma separators
    final buffer = StringBuffer();
    final digits = intPart.split('').reversed.toList();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    final formatted = '${buffer.toString().split('').reversed.join()}.$decPart';

    return '${isNegative ? '-' : ''}${AppConstants.currency}$formatted';
  }

  /// Formats a double as a compact currency string.
  ///
  /// Example: 1234.5 → ₹1,234
  static String formatCompact(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();

    final parts = absAmount.toStringAsFixed(0);
    final buffer = StringBuffer();
    final digits = parts.split('').reversed.toList();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString().split('').reversed.join();
    return '${isNegative ? '-' : ''}${AppConstants.currency}$formatted';
  }

  /// Formats a double as an absolute value currency string.
  ///
  /// Useful for displaying debt amounts without negative sign.
  static String formatAbsolute(double amount) {
    return format(amount.abs());
  }
}
