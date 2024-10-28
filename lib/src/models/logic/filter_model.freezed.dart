// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilterModel {
  String? get employeeNumber => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get firstAndLastName => throw _privateConstructorUsedError;
  String? get commercialName => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;

  /// Create a copy of FilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FilterModelCopyWith<FilterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterModelCopyWith<$Res> {
  factory $FilterModelCopyWith(
          FilterModel value, $Res Function(FilterModel) then) =
      _$FilterModelCopyWithImpl<$Res, FilterModel>;
  @useResult
  $Res call(
      {String? employeeNumber,
      String? fullName,
      String? firstAndLastName,
      String? commercialName,
      String? name});
}

/// @nodoc
class _$FilterModelCopyWithImpl<$Res, $Val extends FilterModel>
    implements $FilterModelCopyWith<$Res> {
  _$FilterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeNumber = freezed,
    Object? fullName = freezed,
    Object? firstAndLastName = freezed,
    Object? commercialName = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      employeeNumber: freezed == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAndLastName: freezed == firstAndLastName
          ? _value.firstAndLastName
          : firstAndLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      commercialName: freezed == commercialName
          ? _value.commercialName
          : commercialName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterModelImplCopyWith<$Res>
    implements $FilterModelCopyWith<$Res> {
  factory _$$FilterModelImplCopyWith(
          _$FilterModelImpl value, $Res Function(_$FilterModelImpl) then) =
      __$$FilterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? employeeNumber,
      String? fullName,
      String? firstAndLastName,
      String? commercialName,
      String? name});
}

/// @nodoc
class __$$FilterModelImplCopyWithImpl<$Res>
    extends _$FilterModelCopyWithImpl<$Res, _$FilterModelImpl>
    implements _$$FilterModelImplCopyWith<$Res> {
  __$$FilterModelImplCopyWithImpl(
      _$FilterModelImpl _value, $Res Function(_$FilterModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FilterModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeNumber = freezed,
    Object? fullName = freezed,
    Object? firstAndLastName = freezed,
    Object? commercialName = freezed,
    Object? name = freezed,
  }) {
    return _then(_$FilterModelImpl(
      employeeNumber: freezed == employeeNumber
          ? _value.employeeNumber
          : employeeNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstAndLastName: freezed == firstAndLastName
          ? _value.firstAndLastName
          : firstAndLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      commercialName: freezed == commercialName
          ? _value.commercialName
          : commercialName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FilterModelImpl extends _FilterModel {
  const _$FilterModelImpl(
      {this.employeeNumber,
      this.fullName,
      this.firstAndLastName,
      this.commercialName,
      this.name})
      : super._();

  @override
  final String? employeeNumber;
  @override
  final String? fullName;
  @override
  final String? firstAndLastName;
  @override
  final String? commercialName;
  @override
  final String? name;

  @override
  String toString() {
    return 'FilterModel(employeeNumber: $employeeNumber, fullName: $fullName, firstAndLastName: $firstAndLastName, commercialName: $commercialName, name: $name)';
  }

  /// Create a copy of FilterModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterModelImplCopyWith<_$FilterModelImpl> get copyWith =>
      __$$FilterModelImplCopyWithImpl<_$FilterModelImpl>(this, _$identity);
}

abstract class _FilterModel extends FilterModel {
  const factory _FilterModel(
      {final String? employeeNumber,
      final String? fullName,
      final String? firstAndLastName,
      final String? commercialName,
      final String? name}) = _$FilterModelImpl;
  const _FilterModel._() : super._();

  @override
  String? get employeeNumber;
  @override
  String? get fullName;
  @override
  String? get firstAndLastName;
  @override
  String? get commercialName;
  @override
  String? get name;

  /// Create a copy of FilterModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterModelImplCopyWith<_$FilterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
