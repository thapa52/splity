import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';

/// Represents a single debt settlement transaction.
///
/// A settlement means: [fromMember] should pay [amount] to [toMember]
/// to settle their share of group expenses.
///
/// Example:
/// ```
/// Settlement(
///   fromMember: 'Dave',
///   toMember: 'Alice',
///   amount: 380.00,
/// )
/// // Means: Dave pays Alice ₹380
/// ```
@freezed
abstract class Settlement with _$Settlement {
  const factory Settlement({
    required String fromMember,
    required String toMember,
    required double amount,
  }) = _Settlement;
}
