/// Base failure class for Splity.
///
/// All errors in the app are represented as [Failure] objects
/// instead of throwing exceptions. This makes error handling
/// predictable, testable, and user-friendly.
///
/// Usage:
/// ```dart
/// // In repository
/// Either<Failure, Group> createGroup(Group group) {
///   try {
///     // save to Hive
///     return Right(group);
///   } catch (e) {
///     return Left(CacheFailure('Failed to save group'));
///   }
/// }
/// ```
sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

/// Failure when local storage (Hive) operations fail.
///
/// Examples: box not found, read/write error, corrupted data.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure when input validation fails.
///
/// Examples: empty group name, negative expense amount.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure for unexpected errors.
///
/// Examples: null pointer, type cast error.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}
