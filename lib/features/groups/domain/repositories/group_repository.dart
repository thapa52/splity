import '../entities/group.dart';

/// Abstract contract for group data operations.
///
/// The domain layer defines what it needs through this interface.
/// The data layer implements it with Hive (or any other storage).
///
/// This separation means:
/// - Domain layer has zero knowledge of Hive
/// - We can swap storage (Hive → SQLite → API) without touching domain
/// - Easy to create fake implementations for testing
abstract class GroupRepository {
  /// Returns all groups sorted by creation date (newest first).
  Future<List<Group>> getGroups();

  /// Returns a single group by its [id].
  ///
  /// Returns `null` if no group exists with the given [id].
  Future<Group?> getGroupById(String id);

  /// Creates a new group and saves it to storage.
  ///
  /// Returns the created [Group].
  Future<Group> createGroup(Group group);

  /// Updates an existing group.
  ///
  /// Returns the updated [Group].
  Future<Group> updateGroup(Group group);

  /// Deletes a group by its [id].
  Future<void> deleteGroup(String id);
}
