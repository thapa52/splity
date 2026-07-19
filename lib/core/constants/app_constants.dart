/// App-wide constants for Splity.
///
/// Contains Hive box names, UI dimensions, animation durations,
/// and other values used across the app.
abstract final class AppConstants {
  // === APP INFO ===
  static const String appName = 'Splity';
  static const String appVersion = '1.0.0';
  static const String currency = '₹';

  // === HIVE BOX NAMES ===
  static const String groupsBox = 'groups_box';
  static const String expensesBox = 'expenses_box';
  static const String settlementsBox = 'settlements_box';

  // === SHARED PREFERENCES KEYS ===
  static const String themeKey = 'is_dark_mode';

  // === UI DIMENSIONS ===
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusSmall = 8.0;
  static const double cardElevation = 2.0;
  static const double iconSize = 24.0;
  static const double iconSizeLarge = 32.0;

  // === PADDING ===
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // === ANIMATION ===
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // === EXPENSE CATEGORIES ===
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Utilities',
    'Rent',
    'Other',
  ];
}
