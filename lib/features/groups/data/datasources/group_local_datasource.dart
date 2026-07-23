import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/group_model.dart';

/// Interface for group local storage operations.
///
/// Defines the contract for Hive operations.
/// Makes it easy to create a fake for testing.
abstract class GroupLocalDatasource {
  Future<List<GroupModel>> getGroups();
  Future<GroupModel?> getGroupById(String id);
  Future<void> saveGroup(GroupModel group);
  Future<void> deleteGroup(String id);
}

/// Hive implementation of [GroupLocalDatasource].
///
/// All Hive-specific code lives here and nowhere else.
/// Uses the group's [id] as the Hive box key for O(1) lookups.
class GroupLocalDatasourceImpl implements GroupLocalDatasource {
  /// Returns the Hive box for groups.
  ///
  /// We get the box each time instead of storing a reference
  /// because the box might not be open when the class is created.
  Box<GroupModel> get _box => Hive.box<GroupModel>(AppConstants.groupsBox);

  @override
  Future<List<GroupModel>> getGroups() async {
    final groups = _box.values.toList();

    // Sort by creation date — newest first
    groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return groups;
  }

  @override
  Future<GroupModel?> getGroupById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> saveGroup(GroupModel group) async {
    await _box.put(group.id, group);
  }

  @override
  Future<void> deleteGroup(String id) async {
    await _box.delete(id);
  }
}
