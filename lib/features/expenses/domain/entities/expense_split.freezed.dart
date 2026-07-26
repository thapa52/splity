// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseSplit {
  String get memberName => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseSplitCopyWith<ExpenseSplit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseSplitCopyWith<$Res> {
  factory $ExpenseSplitCopyWith(
          ExpenseSplit value, $Res Function(ExpenseSplit) then) =
      _$ExpenseSplitCopyWithImpl<$Res, ExpenseSplit>;
  @useResult
  $Res call({String memberName, double amount});
}

/// @nodoc
class _$ExpenseSplitCopyWithImpl<$Res, $Val extends ExpenseSplit>
    implements $ExpenseSplitCopyWith<$Res> {
  _$ExpenseSplitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberName = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseSplitImplCopyWith<$Res>
    implements $ExpenseSplitCopyWith<$Res> {
  factory _$$ExpenseSplitImplCopyWith(
          _$ExpenseSplitImpl value, $Res Function(_$ExpenseSplitImpl) then) =
      __$$ExpenseSplitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String memberName, double amount});
}

/// @nodoc
class __$$ExpenseSplitImplCopyWithImpl<$Res>
    extends _$ExpenseSplitCopyWithImpl<$Res, _$ExpenseSplitImpl>
    implements _$$ExpenseSplitImplCopyWith<$Res> {
  __$$ExpenseSplitImplCopyWithImpl(
      _$ExpenseSplitImpl _value, $Res Function(_$ExpenseSplitImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberName = null,
    Object? amount = null,
  }) {
    return _then(_$ExpenseSplitImpl(
      memberName: null == memberName
          ? _value.memberName
          : memberName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$ExpenseSplitImpl implements _ExpenseSplit {
  const _$ExpenseSplitImpl({required this.memberName, required this.amount});

  @override
  final String memberName;
  @override
  final double amount;

  @override
  String toString() {
    return 'ExpenseSplit(memberName: $memberName, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseSplitImpl &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, memberName, amount);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      __$$ExpenseSplitImplCopyWithImpl<_$ExpenseSplitImpl>(this, _$identity);
}

abstract class _ExpenseSplit implements ExpenseSplit {
  const factory _ExpenseSplit(
      {required final String memberName,
      required final double amount}) = _$ExpenseSplitImpl;

  @override
  String get memberName;
  @override
  double get amount;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
