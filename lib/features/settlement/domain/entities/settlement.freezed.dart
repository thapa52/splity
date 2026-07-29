// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Settlement {
  String get fromMember => throw _privateConstructorUsedError;
  String get toMember => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementCopyWith<Settlement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementCopyWith<$Res> {
  factory $SettlementCopyWith(
          Settlement value, $Res Function(Settlement) then) =
      _$SettlementCopyWithImpl<$Res, Settlement>;
  @useResult
  $Res call({String fromMember, String toMember, double amount});
}

/// @nodoc
class _$SettlementCopyWithImpl<$Res, $Val extends Settlement>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromMember = null,
    Object? toMember = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      fromMember: null == fromMember
          ? _value.fromMember
          : fromMember // ignore: cast_nullable_to_non_nullable
              as String,
      toMember: null == toMember
          ? _value.toMember
          : toMember // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettlementImplCopyWith<$Res>
    implements $SettlementCopyWith<$Res> {
  factory _$$SettlementImplCopyWith(
          _$SettlementImpl value, $Res Function(_$SettlementImpl) then) =
      __$$SettlementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fromMember, String toMember, double amount});
}

/// @nodoc
class __$$SettlementImplCopyWithImpl<$Res>
    extends _$SettlementCopyWithImpl<$Res, _$SettlementImpl>
    implements _$$SettlementImplCopyWith<$Res> {
  __$$SettlementImplCopyWithImpl(
      _$SettlementImpl _value, $Res Function(_$SettlementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromMember = null,
    Object? toMember = null,
    Object? amount = null,
  }) {
    return _then(_$SettlementImpl(
      fromMember: null == fromMember
          ? _value.fromMember
          : fromMember // ignore: cast_nullable_to_non_nullable
              as String,
      toMember: null == toMember
          ? _value.toMember
          : toMember // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$SettlementImpl implements _Settlement {
  const _$SettlementImpl(
      {required this.fromMember, required this.toMember, required this.amount});

  @override
  final String fromMember;
  @override
  final String toMember;
  @override
  final double amount;

  @override
  String toString() {
    return 'Settlement(fromMember: $fromMember, toMember: $toMember, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementImpl &&
            (identical(other.fromMember, fromMember) ||
                other.fromMember == fromMember) &&
            (identical(other.toMember, toMember) ||
                other.toMember == toMember) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fromMember, toMember, amount);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      __$$SettlementImplCopyWithImpl<_$SettlementImpl>(this, _$identity);
}

abstract class _Settlement implements Settlement {
  const factory _Settlement(
      {required final String fromMember,
      required final String toMember,
      required final double amount}) = _$SettlementImpl;

  @override
  String get fromMember;
  @override
  String get toMember;
  @override
  double get amount;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
