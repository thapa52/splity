import '../entities/group.dart';
import '../repositories/group_repository.dart';

/// Retrieves a single group by its unique ID.
///
/// Returns the [Group] if found, or `null` if no group
/// exists with the given [id].
class GetGroupById {
  final GroupRepository _repository;

  const GetGroupById(this._repository);

  Future<Group?> call(String id) async {
    if (id.trim().isEmpty) {
      throw ArgumentError('Group ID cannot be empty');
    }

    return _repository.getGroupById(id);
  }
}
