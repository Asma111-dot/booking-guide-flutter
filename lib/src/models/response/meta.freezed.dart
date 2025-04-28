// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return _Meta.fromJson(json);
}

/// @nodoc
mixin _$Meta {
  Status get status => throw _privateConstructorUsedError;
  bool get fetchedAll => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  bool get showDialog => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  int? get currentPage => throw _privateConstructorUsedError;
  bool? get forgetRoute => throw _privateConstructorUsedError;
  bool? get verify => throw _privateConstructorUsedError;
  int? get nextPage => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;
  String? get nextPageUrl => throw _privateConstructorUsedError;
  int? get perPage => throw _privateConstructorUsedError;
  String? get route => throw _privateConstructorUsedError;
  int? get to => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;

  /// Serializes this Meta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetaCopyWith<Meta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaCopyWith<$Res> {
  factory $MetaCopyWith(Meta value, $Res Function(Meta) then) =
      _$MetaCopyWithImpl<$Res, Meta>;
  @useResult
  $Res call(
      {Status status,
      bool fetchedAll,
      int? id,
      bool showDialog,
      String message,
      String? type,
      String? accessToken,
      int? currentPage,
      bool? forgetRoute,
      bool? verify,
      int? nextPage,
      String? nextCursor,
      String? nextPageUrl,
      int? perPage,
      String? route,
      int? to,
      int? total});
}

/// @nodoc
class _$MetaCopyWithImpl<$Res, $Val extends Meta>
    implements $MetaCopyWith<$Res> {
  _$MetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? fetchedAll = null,
    Object? id = freezed,
    Object? showDialog = null,
    Object? message = null,
    Object? type = freezed,
    Object? accessToken = freezed,
    Object? currentPage = freezed,
    Object? forgetRoute = freezed,
    Object? verify = freezed,
    Object? nextPage = freezed,
    Object? nextCursor = freezed,
    Object? nextPageUrl = freezed,
    Object? perPage = freezed,
    Object? route = freezed,
    Object? to = freezed,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      fetchedAll: null == fetchedAll
          ? _value.fetchedAll
          : fetchedAll // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      showDialog: null == showDialog
          ? _value.showDialog
          : showDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      forgetRoute: freezed == forgetRoute
          ? _value.forgetRoute
          : forgetRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
      verify: freezed == verify
          ? _value.verify
          : verify // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextPage: freezed == nextPage
          ? _value.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as int?,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaImplCopyWith<$Res> implements $MetaCopyWith<$Res> {
  factory _$$MetaImplCopyWith(
          _$MetaImpl value, $Res Function(_$MetaImpl) then) =
      __$$MetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Status status,
      bool fetchedAll,
      int? id,
      bool showDialog,
      String message,
      String? type,
      String? accessToken,
      int? currentPage,
      bool? forgetRoute,
      bool? verify,
      int? nextPage,
      String? nextCursor,
      String? nextPageUrl,
      int? perPage,
      String? route,
      int? to,
      int? total});
}

/// @nodoc
class __$$MetaImplCopyWithImpl<$Res>
    extends _$MetaCopyWithImpl<$Res, _$MetaImpl>
    implements _$$MetaImplCopyWith<$Res> {
  __$$MetaImplCopyWithImpl(_$MetaImpl _value, $Res Function(_$MetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? fetchedAll = null,
    Object? id = freezed,
    Object? showDialog = null,
    Object? message = null,
    Object? type = freezed,
    Object? accessToken = freezed,
    Object? currentPage = freezed,
    Object? forgetRoute = freezed,
    Object? verify = freezed,
    Object? nextPage = freezed,
    Object? nextCursor = freezed,
    Object? nextPageUrl = freezed,
    Object? perPage = freezed,
    Object? route = freezed,
    Object? to = freezed,
    Object? total = freezed,
  }) {
    return _then(_$MetaImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      fetchedAll: null == fetchedAll
          ? _value.fetchedAll
          : fetchedAll // ignore: cast_nullable_to_non_nullable
              as bool,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      showDialog: null == showDialog
          ? _value.showDialog
          : showDialog // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      forgetRoute: freezed == forgetRoute
          ? _value.forgetRoute
          : forgetRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
      verify: freezed == verify
          ? _value.verify
          : verify // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextPage: freezed == nextPage
          ? _value.nextPage
          : nextPage // ignore: cast_nullable_to_non_nullable
              as int?,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      nextPageUrl: freezed == nextPageUrl
          ? _value.nextPageUrl
          : nextPageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      perPage: freezed == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int?,
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      to: freezed == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaImpl extends _Meta {
  const _$MetaImpl(
      {this.status = Status.initial,
      this.fetchedAll = false,
      this.id,
      this.showDialog = false,
      this.message = '',
      this.type,
      this.accessToken,
      this.currentPage,
      this.forgetRoute,
      this.verify,
      this.nextPage,
      this.nextCursor,
      this.nextPageUrl,
      this.perPage,
      this.route,
      this.to,
      this.total})
      : super._();

  factory _$MetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaImplFromJson(json);

  @override
  @JsonKey()
  final Status status;
  @override
  @JsonKey()
  final bool fetchedAll;
  @override
  final int? id;
  @override
  @JsonKey()
  final bool showDialog;
  @override
  @JsonKey()
  final String message;
  @override
  final String? type;
  @override
  final String? accessToken;
  @override
  final int? currentPage;
  @override
  final bool? forgetRoute;
  @override
  final bool? verify;
  @override
  final int? nextPage;
  @override
  final String? nextCursor;
  @override
  final String? nextPageUrl;
  @override
  final int? perPage;
  @override
  final String? route;
  @override
  final int? to;
  @override
  final int? total;

  @override
  String toString() {
    return 'Meta(status: $status, fetchedAll: $fetchedAll, id: $id, showDialog: $showDialog, message: $message, type: $type, accessToken: $accessToken, currentPage: $currentPage, forgetRoute: $forgetRoute, verify: $verify, nextPage: $nextPage, nextCursor: $nextCursor, nextPageUrl: $nextPageUrl, perPage: $perPage, route: $route, to: $to, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fetchedAll, fetchedAll) ||
                other.fetchedAll == fetchedAll) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.showDialog, showDialog) ||
                other.showDialog == showDialog) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.forgetRoute, forgetRoute) ||
                other.forgetRoute == forgetRoute) &&
            (identical(other.verify, verify) || other.verify == verify) &&
            (identical(other.nextPage, nextPage) ||
                other.nextPage == nextPage) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      fetchedAll,
      id,
      showDialog,
      message,
      type,
      accessToken,
      currentPage,
      forgetRoute,
      verify,
      nextPage,
      nextCursor,
      nextPageUrl,
      perPage,
      route,
      to,
      total);

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      __$$MetaImplCopyWithImpl<_$MetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaImplToJson(
      this,
    );
  }
}

abstract class _Meta extends Meta {
  const factory _Meta(
      {final Status status,
      final bool fetchedAll,
      final int? id,
      final bool showDialog,
      final String message,
      final String? type,
      final String? accessToken,
      final int? currentPage,
      final bool? forgetRoute,
      final bool? verify,
      final int? nextPage,
      final String? nextCursor,
      final String? nextPageUrl,
      final int? perPage,
      final String? route,
      final int? to,
      final int? total}) = _$MetaImpl;
  const _Meta._() : super._();

  factory _Meta.fromJson(Map<String, dynamic> json) = _$MetaImpl.fromJson;

  @override
  Status get status;
  @override
  bool get fetchedAll;
  @override
  int? get id;
  @override
  bool get showDialog;
  @override
  String get message;
  @override
  String? get type;
  @override
  String? get accessToken;
  @override
  int? get currentPage;
  @override
  bool? get forgetRoute;
  @override
  bool? get verify;
  @override
  int? get nextPage;
  @override
  String? get nextCursor;
  @override
  String? get nextPageUrl;
  @override
  int? get perPage;
  @override
  String? get route;
  @override
  int? get to;
  @override
  int? get total;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
