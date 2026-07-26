// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseLocalDatasourceHash() =>
    r'1dd581c75607bd741b8e1813f6ca6c9fc058cf50';

/// Provides the [ExpenseLocalDatasource] implementation.
///
/// Copied from [expenseLocalDatasource].
@ProviderFor(expenseLocalDatasource)
final expenseLocalDatasourceProvider =
    AutoDisposeProvider<ExpenseLocalDatasource>.internal(
  expenseLocalDatasource,
  name: r'expenseLocalDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseLocalDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseLocalDatasourceRef
    = AutoDisposeProviderRef<ExpenseLocalDatasource>;
String _$expenseRepositoryHash() => r'28fee46e4f5a19ae6c478d52c2c07f6f37e75b1c';

/// Provides the [ExpenseRepositoryImpl].
///
/// Copied from [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepositoryImpl>.internal(
  expenseRepository,
  name: r'expenseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepositoryImpl>;
String _$getExpensesByGroupHash() =>
    r'd72a03f9dacf594e97ec7cad86118762c1eb7e28';

/// Provides the [GetExpensesByGroup] use case.
///
/// Copied from [getExpensesByGroup].
@ProviderFor(getExpensesByGroup)
final getExpensesByGroupProvider =
    AutoDisposeProvider<GetExpensesByGroup>.internal(
  getExpensesByGroup,
  name: r'getExpensesByGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getExpensesByGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetExpensesByGroupRef = AutoDisposeProviderRef<GetExpensesByGroup>;
String _$addExpenseHash() => r'4f9104b43a4a727daf7c883157a56b38cb893a60';

/// Provides the [AddExpense] use case.
///
/// Copied from [addExpense].
@ProviderFor(addExpense)
final addExpenseProvider = AutoDisposeProvider<AddExpense>.internal(
  addExpense,
  name: r'addExpenseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddExpenseRef = AutoDisposeProviderRef<AddExpense>;
String _$deleteExpenseHash() => r'5fa531c21c523e0556aad83ef18f34e8411241f8';

/// Provides the [DeleteExpense] use case.
///
/// Copied from [deleteExpense].
@ProviderFor(deleteExpense)
final deleteExpenseProvider = AutoDisposeProvider<DeleteExpense>.internal(
  deleteExpense,
  name: r'deleteExpenseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteExpenseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteExpenseRef = AutoDisposeProviderRef<DeleteExpense>;
String _$expenseNotifierHash() => r'c66d0ccc53c4726f3f9e71b34fbef16b6ef3f7a3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ExpenseNotifier
    extends BuildlessAutoDisposeNotifier<ExpenseState> {
  late final String groupId;

  ExpenseState build(
    String groupId,
  );
}

/// Manages the state for the expenses feature.
///
/// Takes a [groupId] parameter so it loads expenses
/// for a specific group only.
///
/// Copied from [ExpenseNotifier].
@ProviderFor(ExpenseNotifier)
const expenseNotifierProvider = ExpenseNotifierFamily();

/// Manages the state for the expenses feature.
///
/// Takes a [groupId] parameter so it loads expenses
/// for a specific group only.
///
/// Copied from [ExpenseNotifier].
class ExpenseNotifierFamily extends Family<ExpenseState> {
  /// Manages the state for the expenses feature.
  ///
  /// Takes a [groupId] parameter so it loads expenses
  /// for a specific group only.
  ///
  /// Copied from [ExpenseNotifier].
  const ExpenseNotifierFamily();

  /// Manages the state for the expenses feature.
  ///
  /// Takes a [groupId] parameter so it loads expenses
  /// for a specific group only.
  ///
  /// Copied from [ExpenseNotifier].
  ExpenseNotifierProvider call(
    String groupId,
  ) {
    return ExpenseNotifierProvider(
      groupId,
    );
  }

  @override
  ExpenseNotifierProvider getProviderOverride(
    covariant ExpenseNotifierProvider provider,
  ) {
    return call(
      provider.groupId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'expenseNotifierProvider';
}

/// Manages the state for the expenses feature.
///
/// Takes a [groupId] parameter so it loads expenses
/// for a specific group only.
///
/// Copied from [ExpenseNotifier].
class ExpenseNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ExpenseNotifier, ExpenseState> {
  /// Manages the state for the expenses feature.
  ///
  /// Takes a [groupId] parameter so it loads expenses
  /// for a specific group only.
  ///
  /// Copied from [ExpenseNotifier].
  ExpenseNotifierProvider(
    String groupId,
  ) : this._internal(
          () => ExpenseNotifier()..groupId = groupId,
          from: expenseNotifierProvider,
          name: r'expenseNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expenseNotifierHash,
          dependencies: ExpenseNotifierFamily._dependencies,
          allTransitiveDependencies:
              ExpenseNotifierFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  ExpenseNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  ExpenseState runNotifierBuild(
    covariant ExpenseNotifier notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(ExpenseNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExpenseNotifierProvider._internal(
        () => create()..groupId = groupId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ExpenseNotifier, ExpenseState>
      createElement() {
    return _ExpenseNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseNotifierProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpenseNotifierRef on AutoDisposeNotifierProviderRef<ExpenseState> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _ExpenseNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ExpenseNotifier, ExpenseState>
    with ExpenseNotifierRef {
  _ExpenseNotifierProviderElement(super.provider);

  @override
  String get groupId => (origin as ExpenseNotifierProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
