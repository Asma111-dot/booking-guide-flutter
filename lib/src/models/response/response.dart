import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'meta.dart';

part 'response.freezed.dart';

@freezed
class Response<T> with _$Response<T> {
  const Response._();

  const factory Response({T? data, @Default([]) List<String> deleted, @Default(Meta(message: '')) Meta meta}) = _Response<T>;

  init() => copyWith.meta(status: Status.initial);
  bool isInit() => meta.status == Status.initial;

  setResponse(Response<T> response) => copyWith(
    data: response.data,
    meta: response.meta,
    deleted: response.deleted,
  );

  setData(value) => copyWith(data: value);

  setLoading() => copyWith.meta(status: Status.loading);
  bool isLoading() => meta.status == Status.loading;

  setLoaded() => copyWith.meta(status: Status.loaded);
  bool isLoaded() => meta.status == Status.loaded;

  setError([String message = '']) =>
      copyWith.meta(status: Status.error, message: message);
  bool isError() => meta.status == Status.error;

  setFetchAll(bool value) => copyWith.meta(fetchedAll: value);
  bool isFetchAll() => meta.fetchedAll;

  setEmpty() {
    return copyWith.meta(status: Status.empty);
  }
  bool isEmpty() => meta.status == Status.empty;

  setCancelled() => copyWith.meta(status: Status.cancelled);
  bool isCancelled() => meta.status == Status.cancelled;

  bool isLast() => meta.isLast();

  String message() => meta.message;
}