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
  @JsonKey(includeFromJson: false, includeToJson: false)
  Status get status => throw _privateConstructorUsedError;
  bool get fetchedAll => throw _privateConstructorUsedError;
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_token')
  String? get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_dialog')
  bool get showDialog => throw _privateConstructorUsedError;
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'type')
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'route')
  String? get route => throw _privateConstructorUsedError;
  @JsonKey(name: 'forget_route')
  bool? get forgetRoute => throw _privateConstructorUsedError;
  @JsonKey(name: 'verify')
  bool? get verify => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_page')
  int? get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_page')
  int? get nextPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_cursor')
  String? get nextCursor => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_page_url')
  String? get nextPageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int? get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'to')
  int? get to => throw _privateConstructorUsedError;
  @JsonKey(name: 'total')
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
      {@JsonKey(includeFromJson: false, includeToJson: false) Status status,
      bool fetchedAll,
      int? id,
      @JsonKey(name: 'access_token') String? accessToken,
      @JsonKey(name: 'show_dialog') bool showDialog,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type') String? type,
      @JsonKey(name: 'route') String? route,
      @JsonKey(name: 'forget_route') bool? forgetRoute,
      @JsonKey(name: 'verify') bool? verify,
      @JsonKey(name: 'current_page') int? currentPage,
      @JsonKey(name: 'next_page') int? nextPage,
      @JsonKey(name: 'next_cursor') String? nextCursor,
      @JsonKey(name: 'next_page_url') String? nextPageUrl,
      @JsonKey(name: 'per_page') int? perPage,
      @JsonKey(name: 'to') int? to,
      @JsonKey(name: 'total') int? total});
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
    Object? accessToken = freezed,
    Object? showDialog = null,
    Object? message = null,
    Object? type = freezed,
    Object? route = freezed,
    Object? forgetRoute = freezed,
    Object? verify = freezed,
    Object? currentPage = freezed,
    Object? nextPage = freezed,
    Object? nextCursor = freezed,
    Object? nextPageUrl = freezed,
    Object? perPage = freezed,
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
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
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
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      forgetRoute: freezed == forgetRoute
          ? _value.forgetRoute
          : forgetRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
      verify: freezed == verify
          ? _value.verify
          : verify // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
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
      {@JsonKey(includeFromJson: false, includeToJson: false) Status status,
      bool fetchedAll,
      int? id,
      @JsonKey(name: 'access_token') String? accessToken,
      @JsonKey(name: 'show_dialog') bool showDialog,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type') String? type,
      @JsonKey(name: 'route') String? route,
      @JsonKey(name: 'forget_route') bool? forgetRoute,
      @JsonKey(name: 'verify') bool? verify,
      @JsonKey(name: 'current_page') int? currentPage,
      @JsonKey(name: 'next_page') int? nextPage,
      @JsonKey(name: 'next_cursor') String? nextCursor,
      @JsonKey(name: 'next_page_url') String? nextPageUrl,
      @JsonKey(name: 'per_page') int? perPage,
      @JsonKey(name: 'to') int? to,
      @JsonKey(name: 'total') int? total});
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
    Object? accessToken = freezed,
    Object? showDialog = null,
    Object? message = null,
    Object? type = freezed,
    Object? route = freezed,
    Object? forgetRoute = freezed,
    Object? verify = freezed,
    Object? currentPage = freezed,
    Object? nextPage = freezed,
    Object? nextCursor = freezed,
    Object? nextPageUrl = freezed,
    Object? perPage = freezed,
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
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
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
      route: freezed == route
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as String?,
      forgetRoute: freezed == forgetRoute
          ? _value.forgetRoute
          : forgetRoute // ignore: cast_nullable_to_non_nullable
              as bool?,
      verify: freezed == verify
          ? _value.verify
          : verify // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentPage: freezed == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$MetaImpl extends _Meta with DiagnosticableTreeMixin {
  const _$MetaImpl(
      {@JsonKey(includeFromJson: false, includeToJson: false)
      this.status = Status.initial,
      this.fetchedAll = false,
      this.id,
      @JsonKey(name: 'access_token') this.accessToken,
      @JsonKey(name: 'show_dialog') this.showDialog = false,
      @JsonKey(name: 'message') this.message = '',
      @JsonKey(name: 'type') this.type,
      @JsonKey(name: 'route') this.route,
      @JsonKey(name: 'forget_route') this.forgetRoute,
      @JsonKey(name: 'verify') this.verify,
      @JsonKey(name: 'current_page') this.currentPage,
      @JsonKey(name: 'next_page') this.nextPage,
      @JsonKey(name: 'next_cursor') this.nextCursor,
      @JsonKey(name: 'next_page_url') this.nextPageUrl,
      @JsonKey(name: 'per_page') this.perPage,
      @JsonKey(name: 'to') this.to,
      @JsonKey(name: 'total') this.total})
      : super._();

  factory _$MetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaImplFromJson(json);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Status status;
  @override
  @JsonKey()
  final bool fetchedAll;
  @override
  final int? id;
  @override
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @override
  @JsonKey(name: 'show_dialog')
  final bool showDialog;
  @override
  @JsonKey(name: 'message')
  final String message;
  @override
  @JsonKey(name: 'type')
  final String? type;
  @override
  @JsonKey(name: 'route')
  final String? route;
  @override
  @JsonKey(name: 'forget_route')
  final bool? forgetRoute;
  @override
  @JsonKey(name: 'verify')
  final bool? verify;
  @override
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @override
  @JsonKey(name: 'next_page')
  final int? nextPage;
  @override
  @JsonKey(name: 'next_cursor')
  final String? nextCursor;
  @override
  @JsonKey(name: 'next_page_url')
  final String? nextPageUrl;
  @override
  @JsonKey(name: 'per_page')
  final int? perPage;
  @override
  @JsonKey(name: 'to')
  final int? to;
  @override
  @JsonKey(name: 'total')
  final int? total;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Meta(status: $status, fetchedAll: $fetchedAll, id: $id, accessToken: $accessToken, showDialog: $showDialog, message: $message, type: $type, route: $route, forgetRoute: $forgetRoute, verify: $verify, currentPage: $currentPage, nextPage: $nextPage, nextCursor: $nextCursor, nextPageUrl: $nextPageUrl, perPage: $perPage, to: $to, total: $total)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Meta'))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('fetchedAll', fetchedAll))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('accessToken', accessToken))
      ..add(DiagnosticsProperty('showDialog', showDialog))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('route', route))
      ..add(DiagnosticsProperty('forgetRoute', forgetRoute))
      ..add(DiagnosticsProperty('verify', verify))
      ..add(DiagnosticsProperty('currentPage', currentPage))
      ..add(DiagnosticsProperty('nextPage', nextPage))
      ..add(DiagnosticsProperty('nextCursor', nextCursor))
      ..add(DiagnosticsProperty('nextPageUrl', nextPageUrl))
      ..add(DiagnosticsProperty('perPage', perPage))
      ..add(DiagnosticsProperty('to', to))
      ..add(DiagnosticsProperty('total', total));
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
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.showDialog, showDialog) ||
                other.showDialog == showDialog) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.forgetRoute, forgetRoute) ||
                other.forgetRoute == forgetRoute) &&
            (identical(other.verify, verify) || other.verify == verify) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.nextPage, nextPage) ||
                other.nextPage == nextPage) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.nextPageUrl, nextPageUrl) ||
                other.nextPageUrl == nextPageUrl) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
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
      accessToken,
      showDialog,
      message,
      type,
      route,
      forgetRoute,
      verify,
      currentPage,
      nextPage,
      nextCursor,
      nextPageUrl,
      perPage,
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
      {@JsonKey(includeFromJson: false, includeToJson: false)
      final Status status,
      final bool fetchedAll,
      final int? id,
      @JsonKey(name: 'access_token') final String? accessToken,
      @JsonKey(name: 'show_dialog') final bool showDialog,
      @JsonKey(name: 'message') final String message,
      @JsonKey(name: 'type') final String? type,
      @JsonKey(name: 'route') final String? route,
      @JsonKey(name: 'forget_route') final bool? forgetRoute,
      @JsonKey(name: 'verify') final bool? verify,
      @JsonKey(name: 'current_page') final int? currentPage,
      @JsonKey(name: 'next_page') final int? nextPage,
      @JsonKey(name: 'next_cursor') final String? nextCursor,
      @JsonKey(name: 'next_page_url') final String? nextPageUrl,
      @JsonKey(name: 'per_page') final int? perPage,
      @JsonKey(name: 'to') final int? to,
      @JsonKey(name: 'total') final int? total}) = _$MetaImpl;
  const _Meta._() : super._();

  factory _Meta.fromJson(Map<String, dynamic> json) = _$MetaImpl.fromJson;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Status get status;
  @override
  bool get fetchedAll;
  @override
  int? get id;
  @override
  @JsonKey(name: 'access_token')
  String? get accessToken;
  @override
  @JsonKey(name: 'show_dialog')
  bool get showDialog;
  @override
  @JsonKey(name: 'message')
  String get message;
  @override
  @JsonKey(name: 'type')
  String? get type;
  @override
  @JsonKey(name: 'route')
  String? get route;
  @override
  @JsonKey(name: 'forget_route')
  bool? get forgetRoute;
  @override
  @JsonKey(name: 'verify')
  bool? get verify;
  @override
  @JsonKey(name: 'current_page')
  int? get currentPage;
  @override
  @JsonKey(name: 'next_page')
  int? get nextPage;
  @override
  @JsonKey(name: 'next_cursor')
  String? get nextCursor;
  @override
  @JsonKey(name: 'next_page_url')
  String? get nextPageUrl;
  @override
  @JsonKey(name: 'per_page')
  int? get perPage;
  @override
  @JsonKey(name: 'to')
  int? get to;
  @override
  @JsonKey(name: 'total')
  int? get total;

  /// Create a copy of Meta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetaImplCopyWith<_$MetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
