import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/group_local_datasource.dart';
import '../../data/models/group_model.dart';
import '../../data/repositories/group_repository_impl.dart';
import '../../domain/entities/group.dart';
import '../../domain/usecases/create_group.dart';
import '../../domain/usecases/delete_group.dart';
import '../../domain/usecases/get_groups.dart';

part 'group_provider.g.dart';

// ===================================================================
// STATE
// ===================================================================

/// Represents the UI state for the groups feature.
class GroupState {
  final List<Group> groups;
  final bool isLoading;
  final String? errorMessage;

  const GroupState({
    this.groups = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Creates a copy with updated fields.
  GroupState copyWith({
    List<Group>? groups,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GroupState(
      groups: groups ?? this.groups,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Convenience getters for UI
  bool get hasGroups => groups.isNotEmpty;
  bool get hasError => errorMessage != null;
}

// ===================================================================
// DEPENDENCY PROVIDERS
// ===================================================================

/// Provides the Hive box for groups.
///
/// The box must be opened before this provider is used.
/// We open it in main.dart during app initialization.
@riverpod
Box<GroupModel> groupBox(Ref ref) {
  return Hive.box<GroupModel>(AppConstants.groupsBox);
}

/// Provides the [GroupLocalDatasource] implementation.
@riverpod
GroupLocalDatasource groupLocalDatasource(Ref ref) {
  return GroupLocalDatasourceImpl();
}

/// Provides the [GroupRepositoryImpl].
@riverpod
GroupRepositoryImpl groupRepository(Ref ref) {
  final datasource = ref.watch(groupLocalDatasourceProvider);
  return GroupRepositoryImpl(datasource);
}

// ===================================================================
// USE CASE PROVIDERS
// ===================================================================

/// Provides the [GetGroups] use case.
@riverpod
GetGroups getGroups(Ref ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return GetGroups(repository);
}

/// Provides the [CreateGroup] use case.
@riverpod
CreateGroup createGroup(Ref ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return CreateGroup(repository);
}

/// Provides the [DeleteGroup] use case.
@riverpod
DeleteGroup deleteGroup(Ref ref) {
  final repository = ref.watch(groupRepositoryProvider);
  return DeleteGroup(repository);
}

// ===================================================================
// NOTIFIER
// ===================================================================

/// Manages the state for the groups feature.
///
/// Handles loading groups, creating new groups,
/// and deleting existing groups.
@riverpod
class GroupNotifier extends _$GroupNotifier {
  @override
  GroupState build() {
    // Load groups when the notifier is first created
    _loadGroups();
    return const GroupState(isLoading: true);
  }

  /// Loads all groups from storage.
  Future<void> _loadGroups() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(getGroupsProvider);
      final groups = await useCase();
      state = state.copyWith(groups: groups, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load groups. Please try again.',
      );
    }
  }

  /// Refreshes the groups list.
  ///
  /// Called after creating or deleting a group.
  Future<void> refresh() async {
    await _loadGroups();
  }

  /// Creates a new group.
  ///
  /// Returns `true` if successful, `false` if failed.
  Future<bool> createNewGroup(Group group) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(createGroupProvider);
      await useCase(group);
      await _loadGroups();
      return true;
    } on ArgumentError catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create group. Please try again.',
      );
      return false;
    }
  }

  /// Deletes a group by its [id].
  ///
  /// Returns `true` if successful, `false` if failed.
  Future<bool> removeGroup(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(deleteGroupProvider);
      await useCase(id);
      await _loadGroups();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete group. Please try again.',
      );
      return false;
    }
  }
}
