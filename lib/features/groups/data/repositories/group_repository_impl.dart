import '../../../../core/errors/failure.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_local_datasource.dart';
import '../models/group_model.dart';

/// Hive implementation of [GroupRepository].
///
/// Converts between [GroupModel] (data layer) and
/// [Group] entity (domain layer).
///
/// Wraps all data source errors in [CacheFailure] so
/// the domain layer never sees raw Hive exceptions.
class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDatasource _datasource;

  const GroupRepositoryImpl(this._datasource);

  @override
  Future<List<Group>> getGroups() async {
    try {
      final models = await _datasource.getGroups();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw CacheFailure('Failed to retrieve groups: $e');
    }
  }

  @override
  Future<Group?> getGroupById(String id) async {
    try {
      final model = await _datasource.getGroupById(id);
      return model?.toEntity();
    } catch (e) {
      throw CacheFailure('Failed to retrieve group: $e');
    }
  }

  @override
  Future<Group> createGroup(Group group) async {
    try {
      final model = GroupModel.fromEntity(group);
      await _datasource.saveGroup(model);
      return group;
    } catch (e) {
      throw CacheFailure('Failed to create group: $e');
    }
  }

  @override
  Future<Group> updateGroup(Group group) async {
    try {
      final model = GroupModel.fromEntity(group);
      await _datasource.saveGroup(model);
      return group;
    } catch (e) {
      throw CacheFailure('Failed to update group: $e');
    }
  }

  @override
  Future<void> deleteGroup(String id) async {
    try {
      await _datasource.deleteGroup(id);
    } catch (e) {
      throw CacheFailure('Failed to delete group: $e');
    }
  }
}
