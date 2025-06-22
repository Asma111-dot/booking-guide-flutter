import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/alert.dart';

part 'meta.freezed.dart';
part 'meta.g.dart';

enum Status { initial, loading, loaded, error, empty, cancelled }

@freezed
class Meta with _$Meta {
  const Meta._();

  const factory Meta({
    @Default(Status.initial) Status status,
    @Default(false) bool fetchedAll,
    int? id,
    @Default(false) bool showDialog,
    @Default('') String message,
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
    int? total,
  }) = _Meta;

  // factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  factory Meta.fromJson(Map<String, dynamic> json) {
    String message = '';

    // أولوية 1: message الرئيسي
    if (json.containsKey('message') && json['message'] is String) {
      message = json['message'];
    }

    // أولوية 2: error كسلسلة نصية
    else if (json.containsKey('error') && json['error'] is String) {
      message = json['error'];
    }

    // أولوية 3: error كـ Map بداخله message
    else if (json.containsKey('error') &&
        json['error'] is Map &&
        json['error']['message'] is String) {
      message = json['error']['message'];
    }

    // أولوية 4: details.message
    if (json.containsKey('details') &&
        json['details'] is Map &&
        json['details']['message'] is String) {
      message = json['details']['message'];
    }

    return Meta(
      message: message,
      // message: message.isNotEmpty ? message : 'حدث خطأ غير متوقع',
      status: Status.error,
    );
  }

  // --- Custom methods ---

  Meta setValue(Meta meta) => copyWith(
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

  Meta init() => copyWith(status: Status.initial);
  bool isInit() => status == Status.initial;

  Meta setFetchedAll(bool value) => copyWith(fetchedAll: value);
  bool isFetchedAll() => fetchedAll;

  Meta setLoading() => copyWith(status: Status.loading);
  bool isLoading() => status == Status.loading;

  Meta setLoaded() => copyWith(status: Status.loaded);
  bool isLoaded() => status == Status.loaded;

  Meta setCancelled() => copyWith(status: Status.cancelled);
  bool isCancelled() => status == Status.cancelled;

  Meta setError([String message = '']) => copyWith(status: Status.error, message: message);
  bool isError() => status == Status.error;

  Meta setEmpty([String message = '']) => copyWith(status: Status.empty, message: message);
  bool isEmpty() => status == Status.empty;

  bool isLast() => to == null || to == total;
  bool isCursor() => (nextCursor?.isNotEmpty ?? false);

  bool isSuccessType() => type == Alert.success.name;
  bool isErrorType() => type == Alert.error.name;
  bool isWarningType() => type == Alert.warning.name;
  bool isInfoType() => type == Alert.info.name;
}
