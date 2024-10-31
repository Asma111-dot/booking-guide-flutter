import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../enums/alert.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

enum Status { initial, loading, loaded, error, empty, cancelled }

@freezed
class Meta with _$Meta {

  const Meta._();

  const factory Meta({
    @Default(Status.initial) @JsonKey(includeFromJson: false, includeToJson: false) Status status,
    @Default(false) bool fetchedAll,
    int? id,
    @Default(false) @JsonKey(name: 'show_dialog') bool showDialog,
    @Default('') @JsonKey(name: 'message') String message,
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'current_page') int? currentPage,
    @JsonKey(name: 'next_page') int? nextPage,
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'next_page_url') String? nextPageUrl,
    @JsonKey(name: 'per_page') int? perPage,
    @JsonKey(name: 'to') int? to,
    @JsonKey(name: 'total') int? total,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  setValue(Meta meta) => copyWith(
    status: meta.status,
    type: meta.type,
    fetchedAll: meta.fetchedAll,
    showDialog: meta.showDialog,
    message: meta.message,
    currentPage: meta.currentPage,
    forgetRoute: meta.forgetRoute,
    nextPage: meta.nextPage,
    perPage: meta.perPage,
    route: meta.route,
    to: meta.to,
    total: meta.total,
    verify: meta.verify,
  );

  init() => copyWith(status: Status.initial);
  bool isInit() => status == Status.initial;

  setFetchedAll(bool value) => copyWith(fetchedAll: value);
  bool isFetchedAll() => fetchedAll;

  setLoading() => copyWith(status: Status.loading);
  bool isLoading() => status == Status.loading;

  setLoaded() => copyWith(status: Status.loaded);
  bool isLoaded() => status == Status.loaded;

  setCancelled() => copyWith(status: Status.loaded);
  bool isCancelled() => status == Status.cancelled;

  setError([String message = '']) =>
      copyWith(status: Status.error, message: message);

  bool isError() => status == Status.error;

  setEmpty([String message = '']) => copyWith(status: Status.empty, message: message);
  bool isEmpty() => status == Status.empty;

  bool isLast() => to == null || to == total;

  bool isCursor() => (nextCursor?.isNotEmpty ?? false);

  bool isSuccessType() => type == Alert.success.name;
  bool isErrorType() => type == Alert.error.name;
  bool isWarningType() => type == Alert.warning.name;
  bool isInfoType() => type == Alert.info.name;
}