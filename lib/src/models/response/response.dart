import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'meta.dart';

part 'response.freezed.dart';

// mange state in my app is a (generic)***
@freezed //independent to copyWith and (==)equality
class Response<T> with _$Response<T> {
  const Response._();

  const factory Response({
    T? data,
    @Default([]) List<String> deleted,
    @Default(Meta(message: '')) Meta meta,
  }) = _Response<T>;

  Response<T> init() => copyWith(meta: meta.copyWith(status: Status.initial));

  bool isInit() => meta.status == Status.initial;

  Response<T> setResponse(Response<T> response) => copyWith(
        data: response.data,
        meta: response.meta,
        deleted: response.deleted,
      );

  Response<T> setData(T value) => copyWith(data: value);

  Response<T> setLoading() =>
      copyWith(meta: meta.copyWith(status: Status.loading));

  bool isLoading() => meta.status == Status.loading;

  Response<T> setLoaded() =>
      copyWith(meta: meta.copyWith(status: Status.loaded));

  bool isLoaded() => meta.status == Status.loaded;

  Response<T> setError([String message = '']) => copyWith(
        meta: meta.copyWith(status: Status.error, message: message),
      );

  bool isError() => meta.status == Status.error;

  Response<T> setFetchAll(bool value) =>
      copyWith(meta: meta.copyWith(fetchedAll: value));

  bool isFetchAll() => meta.fetchedAll;

  Response<T> setEmpty() => copyWith(meta: meta.copyWith(status: Status.empty));

  bool isEmpty() => meta.status == Status.empty;

  Response<T> setCancelled() =>
      copyWith(meta: meta.copyWith(status: Status.cancelled));

  bool isCancelled() => meta.status == Status.cancelled;

  bool isLast() => meta.isLast();

  String message() => meta.message;
}
