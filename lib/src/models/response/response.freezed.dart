// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Response<T> {
  T? get data => throw _privateConstructorUsedError;
  List<String> get deleted => throw _privateConstructorUsedError;
  Meta get meta => throw _privateConstructorUsedError;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResponseCopyWith<T, Response<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseCopyWith<T, $Res> {
  factory $ResponseCopyWith(
          Response<T> value, $Res Function(Response<T>) then) =
      _$ResponseCopyWithImpl<T, $Res, Response<T>>;
  @useResult
  $Res call({T? data, List<String> deleted, Meta meta});

  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$ResponseCopyWithImpl<T, $Res, $Val extends Response<T>>
    implements $ResponseCopyWith<T, $Res> {
  _$ResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? deleted = null,
    Object? meta = null,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
    ) as $Val);
  }

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetaCopyWith<$Res> get meta {
    return $MetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResponseImplCopyWith<T, $Res>
    implements $ResponseCopyWith<T, $Res> {
  factory _$$ResponseImplCopyWith(
          _$ResponseImpl<T> value, $Res Function(_$ResponseImpl<T>) then) =
      __$$ResponseImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({T? data, List<String> deleted, Meta meta});

  @override
  $MetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$ResponseImplCopyWithImpl<T, $Res>
    extends _$ResponseCopyWithImpl<T, $Res, _$ResponseImpl<T>>
    implements _$$ResponseImplCopyWith<T, $Res> {
  __$$ResponseImplCopyWithImpl(
      _$ResponseImpl<T> _value, $Res Function(_$ResponseImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? deleted = null,
    Object? meta = null,
  }) {
    return _then(_$ResponseImpl<T>(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      deleted: null == deleted
          ? _value._deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      meta: null == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Meta,
    ));
  }
}

/// @nodoc

class _$ResponseImpl<T> extends _Response<T> with DiagnosticableTreeMixin {
  const _$ResponseImpl(
      {this.data,
      final List<String> deleted = const [],
      this.meta = const Meta(message: '')})
      : _deleted = deleted,
        super._();

  @override
  final T? data;
  final List<String> _deleted;
  @override
  @JsonKey()
  List<String> get deleted {
    if (_deleted is EqualUnmodifiableListView) return _deleted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deleted);
  }

  @override
  @JsonKey()
  final Meta meta;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Response<$T>(data: $data, deleted: $deleted, meta: $meta)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Response<$T>'))
      ..add(DiagnosticsProperty('data', data))
      ..add(DiagnosticsProperty('deleted', deleted))
      ..add(DiagnosticsProperty('meta', meta));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other._deleted, _deleted) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(_deleted),
      meta);

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResponseImplCopyWith<T, _$ResponseImpl<T>> get copyWith =>
      __$$ResponseImplCopyWithImpl<T, _$ResponseImpl<T>>(this, _$identity);
}

abstract class _Response<T> extends Response<T> {
  const factory _Response(
      {final T? data,
      final List<String> deleted,
      final Meta meta}) = _$ResponseImpl<T>;
  const _Response._() : super._();

  @override
  T? get data;
  @override
  List<String> get deleted;
  @override
  Meta get meta;

  /// Create a copy of Response
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResponseImplCopyWith<T, _$ResponseImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
