// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupBoxHash() => r'6a23ac9d5be28f5801db58bb12f04bd0d769040d';

/// Provides the Hive box for groups.
///
/// The box must be opened before this provider is used.
/// We open it in main.dart during app initialization.
///
/// Copied from [groupBox].
@ProviderFor(groupBox)
final groupBoxProvider = AutoDisposeProvider<Box<GroupModel>>.internal(
  groupBox,
  name: r'groupBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$groupBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupBoxRef = AutoDisposeProviderRef<Box<GroupModel>>;
String _$groupLocalDatasourceHash() =>
    r'90684dff07ff2f4b3d4c9a372119d1e84c81a507';

/// Provides the [GroupLocalDatasource] implementation.
///
/// Copied from [groupLocalDatasource].
@ProviderFor(groupLocalDatasource)
final groupLocalDatasourceProvider =
    AutoDisposeProvider<GroupLocalDatasource>.internal(
  groupLocalDatasource,
  name: r'groupLocalDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupLocalDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupLocalDatasourceRef = AutoDisposeProviderRef<GroupLocalDatasource>;
String _$groupRepositoryHash() => r'1fcacba8657920fbbcf8b8ce89bcfec5bcadbc79';

/// Provides the [GroupRepositoryImpl].
///
/// Copied from [groupRepository].
@ProviderFor(groupRepository)
final groupRepositoryProvider =
    AutoDisposeProvider<GroupRepositoryImpl>.internal(
  groupRepository,
  name: r'groupRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GroupRepositoryRef = AutoDisposeProviderRef<GroupRepositoryImpl>;
String _$getGroupsHash() => r'ba214482c935056aaa17fcaaa3db7b8251f3844b';

/// Provides the [GetGroups] use case.
///
/// Copied from [getGroups].
@ProviderFor(getGroups)
final getGroupsProvider = AutoDisposeProvider<GetGroups>.internal(
  getGroups,
  name: r'getGroupsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getGroupsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetGroupsRef = AutoDisposeProviderRef<GetGroups>;
String _$createGroupHash() => r'899c54f09cb2b2215f84249a81ffe4c250f66a8f';

/// Provides the [CreateGroup] use case.
///
/// Copied from [createGroup].
@ProviderFor(createGroup)
final createGroupProvider = AutoDisposeProvider<CreateGroup>.internal(
  createGroup,
  name: r'createGroupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$createGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateGroupRef = AutoDisposeProviderRef<CreateGroup>;
String _$deleteGroupHash() => r'd21c01ed8de3c6b6923a04d39602f3319531cb3c';

/// Provides the [DeleteGroup] use case.
///
/// Copied from [deleteGroup].
@ProviderFor(deleteGroup)
final deleteGroupProvider = AutoDisposeProvider<DeleteGroup>.internal(
  deleteGroup,
  name: r'deleteGroupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deleteGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteGroupRef = AutoDisposeProviderRef<DeleteGroup>;
String _$groupNotifierHash() => r'9fe0bf428a9f58aed3aa737a597fea567af361bf';

/// Manages the state for the groups feature.
///
/// Handles loading groups, creating new groups,
/// and deleting existing groups.
///
/// Copied from [GroupNotifier].
@ProviderFor(GroupNotifier)
final groupNotifierProvider =
    AutoDisposeNotifierProvider<GroupNotifier, GroupState>.internal(
  GroupNotifier.new,
  name: r'groupNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$groupNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GroupNotifier = AutoDisposeNotifier<GroupState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
