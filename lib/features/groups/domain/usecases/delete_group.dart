import '../repositories/group_repository.dart';

/// Deletes a group by its unique ID.
///
/// Business rules:
/// - Group ID cannot be empty
/// - Deletion is permanent — no undo
///
/// Note: In a future version, this should also delete
/// all expenses associated with the group.
class DeleteGroup {
  final GroupRepository _repository;

  const DeleteGroup(this._repository);

  Future<void> call(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('Group ID cannot be empty');
    }

    await _repository.deleteGroup(id);
  }
}
