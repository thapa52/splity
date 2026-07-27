// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calculateSettlementsUseCaseHash() =>
    r'89689fc238884a7ffcb97586be47e2c2254baf8f';

/// Provides the [CalculateSettlements] use case.
///
/// Copied from [calculateSettlementsUseCase].
@ProviderFor(calculateSettlementsUseCase)
final calculateSettlementsUseCaseProvider =
    AutoDisposeProvider<CalculateSettlements>.internal(
  calculateSettlementsUseCase,
  name: r'calculateSettlementsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calculateSettlementsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculateSettlementsUseCaseRef
    = AutoDisposeProviderRef<CalculateSettlements>;
String _$settlementNotifierHash() =>
    r'e9de3f29623e2e98ef6cc07985bbb98d7f053de0';

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

abstract class _$SettlementNotifier
    extends BuildlessAutoDisposeNotifier<SettlementState> {
  late final String groupId;

  SettlementState build(
    String groupId,
  );
}

/// Manages settlement state for a specific group.
///
/// Watches the expense state and recalculates settlements
/// automatically whenever expenses change.
///
/// Copied from [SettlementNotifier].
@ProviderFor(SettlementNotifier)
const settlementNotifierProvider = SettlementNotifierFamily();

/// Manages settlement state for a specific group.
///
/// Watches the expense state and recalculates settlements
/// automatically whenever expenses change.
///
/// Copied from [SettlementNotifier].
class SettlementNotifierFamily extends Family<SettlementState> {
  /// Manages settlement state for a specific group.
  ///
  /// Watches the expense state and recalculates settlements
  /// automatically whenever expenses change.
  ///
  /// Copied from [SettlementNotifier].
  const SettlementNotifierFamily();

  /// Manages settlement state for a specific group.
  ///
  /// Watches the expense state and recalculates settlements
  /// automatically whenever expenses change.
  ///
  /// Copied from [SettlementNotifier].
  SettlementNotifierProvider call(
    String groupId,
  ) {
    return SettlementNotifierProvider(
      groupId,
    );
  }

  @override
  SettlementNotifierProvider getProviderOverride(
    covariant SettlementNotifierProvider provider,
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
  String? get name => r'settlementNotifierProvider';
}

/// Manages settlement state for a specific group.
///
/// Watches the expense state and recalculates settlements
/// automatically whenever expenses change.
///
/// Copied from [SettlementNotifier].
class SettlementNotifierProvider extends AutoDisposeNotifierProviderImpl<
    SettlementNotifier, SettlementState> {
  /// Manages settlement state for a specific group.
  ///
  /// Watches the expense state and recalculates settlements
  /// automatically whenever expenses change.
  ///
  /// Copied from [SettlementNotifier].
  SettlementNotifierProvider(
    String groupId,
  ) : this._internal(
          () => SettlementNotifier()..groupId = groupId,
          from: settlementNotifierProvider,
          name: r'settlementNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$settlementNotifierHash,
          dependencies: SettlementNotifierFamily._dependencies,
          allTransitiveDependencies:
              SettlementNotifierFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  SettlementNotifierProvider._internal(
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
  SettlementState runNotifierBuild(
    covariant SettlementNotifier notifier,
  ) {
    return notifier.build(
      groupId,
    );
  }

  @override
  Override overrideWith(SettlementNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: SettlementNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<SettlementNotifier, SettlementState>
      createElement() {
    return _SettlementNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SettlementNotifierProvider && other.groupId == groupId;
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
mixin SettlementNotifierRef on AutoDisposeNotifierProviderRef<SettlementState> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _SettlementNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<SettlementNotifier,
        SettlementState> with SettlementNotifierRef {
  _SettlementNotifierProviderElement(super.provider);

  @override
  String get groupId => (origin as SettlementNotifierProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
