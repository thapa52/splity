import '../entities/group.dart';
import '../repositories/group_repository.dart';

/// Retrieves all groups from storage.
///
/// Returns groups sorted by creation date (newest first).
/// Returns an empty list if no groups exist.
class GetGroups {
  final GroupRepository _repository;

  const GetGroups(this._repository);

  Future<List<Group>> call() async {
    return _repository.getGroups();
  }
}
