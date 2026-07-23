import '../entities/group.dart';
import '../repositories/group_repository.dart';

/// Creates a new group with validation.
///
/// Business rules:
/// - Group name cannot be empty
/// - Group must have at least 2 members
/// - Member names cannot be empty
/// - Duplicate member names are not allowed
class CreateGroup {
  final GroupRepository _repository;

  const CreateGroup(this._repository);

  Future<Group> call(Group group) async {
    // Validate group name
    if (group.name.trim().isEmpty) {
      throw ArgumentError('Group name cannot be empty');
    }

    // Validate minimum members
    if (group.members.length < 2) {
      throw ArgumentError('Group must have at least 2 members');
    }

    // Validate no empty member names
    for (final member in group.members) {
      if (member.trim().isEmpty) {
        throw ArgumentError('Member name cannot be empty');
      }
    }

    // Validate no duplicate member names
    final uniqueNames =
        group.members.map((m) => m.trim().toLowerCase()).toSet();
    if (uniqueNames.length != group.members.length) {
      throw ArgumentError('Duplicate member names are not allowed');
    }

    // Clean up member names (trim whitespace)
    final cleanedGroup = group.copyWith(
      name: group.name.trim(),
      members: group.members.map((m) => m.trim()).toList(),
      description: group.description.trim(),
    );

    return _repository.createGroup(cleanedGroup);
  }
}
