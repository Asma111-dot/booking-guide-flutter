import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/foundation.dart';

import '../helpers/general_helper.dart';
import '../helpers/notify_helper.dart';
import '../models/payment.dart' as pay;
import '../models/response/meta.dart';
import '../models/response/response.dart';
import '../utils/data_binding.dart';
import 'connectivity_service.dart';
import 'http_service.dart';

enum Method { post, get, put, delete }

String _errorMessage = trans().checkYourInternetConnectionOrTryAgain;

Future<Response<T>> request<T>({
  required String url,
  Method method = Method.get,
  dynamic body,
  Map<String, dynamic>? queryParameters,
  d.CancelToken? cancelToken,
  String key = 'data',
  bool redirectOnPermissionDenied = true,
  bool showSuccessMessage = true,
  bool showErrorMessage = true,
  File? file,
  String fileFieldName = 'file',
  Map<String, dynamic>? fields,
  bool isMultipart = false,
}) async {
  Future<d.Response<dynamic>> response;

  if (isMultipart) {
    final formMap = <String, dynamic>{
      if (fields != null) ...fields,
    };

    if (file != null) {
      formMap[fileFieldName] = await d.MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      );
    }

    final formData = d.FormData.fromMap(formMap);

    response = HttpService.instance.dio.post(
      url,
      data: formData,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: d.Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  } else {
    switch (method) {
      case Method.post:
        response = HttpService.instance.dio.post(
          url,
          data: body,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
        break;
      case Method.put:
        response = HttpService.instance.dio.put(
          url,
          data: body,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
        break;
      case Method.delete:
        response = HttpService.instance.dio.delete(
          url,
          data: body,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );
        break;
      default:
        response = HttpService.instance.dio.get(
          url,
          queryParameters:
          queryParameters ?? (body is Map<String, dynamic> ? body : null),
          cancelToken: cancelToken,
        );
        break;
    }
  }

  dynamic data;
  List<String> deleted = [];
  Meta meta = const Meta(message: '');

  try {
    if (await ConnectivityService.isDisconnected() &&
        (!Platform.isIOS && kDebugMode)) {
      return Response<T>(
        meta: Meta(
          status: Status.error,
          message: trans().youAreNotConnectedToTheInternet,
        ),
      );
    }

    return await response.then((value) {
      if (kDebugMode) log("📥 Response raw: ${value.data.toString()}");

      dynamic parsed;
      try {
        parsed = value.data is String
            ? jsonDecode(utf8.decode(value.data.codeUnits))
            : value.data;
      } catch (e) {
        debugPrint("❌ JSON Decode Error: $e");
        return Response<T>(
          meta: Meta(message: _errorMessage, status: Status.error),
        );
      }

      try {
        if (parsed is Map && parsed.containsKey(key)) {
          if (parsed[key] is List) {
            if (T.toString() == 'List<String>') {
              data = List<String>.from(parsed[key].map((e) => e.toString()));
            } else {
              data = listModel<T>(parsed[key]);
            }
          } else if (parsed[key] is Map) {
            if (T == pay.Payment) {
              data = pay.Payment.fromJson(parsed[key]);
            } else {
              data = model<T>(parsed[key]);
            }
          }

          if (parsed.containsKey('deleted') && parsed['deleted'] is List) {
            deleted = parsed['deleted'].cast<String>();
          }

          if (parsed.containsKey('meta') && parsed['meta'] != null) {
            meta = Meta.fromJson(Map<String, dynamic>.from(parsed['meta']));
            if (parsed.containsKey('token')) {
              meta = meta.copyWith(accessToken: parsed['token']);
            }
          } else {
            try {
              meta = Meta.fromJson(Map<String, dynamic>.from(parsed));
            } catch (_) {
              meta = const Meta(status: Status.loaded, message: '');
            }

            if (parsed.containsKey('token')) {
              meta = meta.copyWith(accessToken: parsed['token']);
            }
          }

          meta = meta.copyWith(
            status: (T.toString() != 'dynamic' &&
                ((parsed[key] is List && (parsed[key] as List).isEmpty) ||
                    parsed[key] == null))
                ? Status.empty
                : Status.loaded,
          );
        } else {
          meta = Meta.fromJson(Map<String, dynamic>.from(parsed));
          meta = meta.copyWith(status: Status.loaded);
        }

        if (showSuccessMessage && method != Method.get) showMessage(meta);

        debugPrint(
            "✅ Dio Response:\nT is ${T.toString()}\nData: ${data.runtimeType}\nMeta: $meta\nDeleted: $deleted");

        return Response<T>(
            data: data == null ? null as T : data as T,
            deleted: deleted,
            meta: meta);
      } catch (e, stack) {
        debugPrint('❌ Response Handling Error:\n$e\n$stack\n$url');
        return Response<T>(
          meta: Meta(message: _errorMessage, status: Status.error),
        );
      }
    });
  } on d.DioException catch (e) {
    try {
      if (d.CancelToken.isCancel(e)) {
        meta = meta.copyWith(status: Status.cancelled);
      } else if (e.response != null) {
        if (redirectOnPermissionDenied && e.response!.statusCode == 401) {
          await clearAllLocalDataAndNavigate();
        }

        if (e.response!.data != null && e.response!.data is Map) {
          final errorData = Map<String, dynamic>.from(e.response!.data);

          String errorMessage = errorData['message'] ??
              errorData['error'] ??
              errorData['exception'] ??
              _errorMessage;

          meta = Meta(
            status: Status.error,
            message: errorMessage,
          );
        }
      } else {
        meta = Meta(message: _errorMessage, status: Status.error);
      }

      debugPrint("❌ Dio Error: ${e.message}\nMeta: $meta");

      if (showErrorMessage && method != Method.get) showMessage(meta);

      return Response<T>(meta: meta);
    } catch (e, stack) {
      debugPrint('❌ Catch Dio Error:\n$e\n$stack\n$url');

      return Response<T>(
        meta: Meta(message: _errorMessage, status: Status.error),
      );
    }
  }
}

void showMessage(Meta meta) {
  if (meta.message.isNotEmpty) {
    showNotify(
      alert: fromAlertName(meta.type),
      message: meta.message,
    );
  }
}
