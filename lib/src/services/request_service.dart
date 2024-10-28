import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as d;
import 'package:flutter/foundation.dart';

import '../helpers/general_helper.dart';
import '../helpers/notify_helper.dart';
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
}) async {

  Future<d.Response<dynamic>> response;

  // First request in app
  // if(url == allDataFetchUrl()) await HttpService.instance.setDefaultHeaders();

  // if(kDebugMode) await Future.delayed(const Duration(seconds: 1));

  switch(method) {
    case Method.post:
      response = HttpService.instance.dio.post(url, data: body, queryParameters: queryParameters, cancelToken: cancelToken);
      break;
    case Method.put:
      response =  HttpService.instance.dio.put(url, data: body, queryParameters: queryParameters, cancelToken: cancelToken);
      break;
    case Method.delete:
      response = HttpService.instance.dio.delete(url, data: body, queryParameters: queryParameters, cancelToken: cancelToken);
      break;
    default:
      response = HttpService.instance.dio.get(url, queryParameters: body ?? queryParameters, cancelToken: cancelToken);
      break;
  }

  dynamic data;
  List<String> deleted = [];
  Meta meta = const Meta(message: '');

  try {
    // Not working in iOS Debug
    if(await ConnectivityService.isDisconnected() && (!Platform.isIOS && kDebugMode)) {
      return Response<T>(meta: Meta(
        status: Status.error,
        message: trans().youAreNotConnectedToTheInternet,
      ));
    }

    return await response.then((value) {

      if(kDebugMode) log(value.data.toString());

      try {

        if(value.data is Map && (value.data as Map).containsKey(key)) {
          if(value.data[key] is List) {
            data = listModel<T>(value.data[key]);
          }
          else if(value.data[key] is Map) {
            data = model<T>(value.data[key]);
          }
          else {
            data = value.data[key];
          }

          if((value.data as Map).containsKey('deleted') && value.data['deleted'] is List) {
            deleted = value.data['deleted'].cast<String>();
          }

          if((value.data as Map).containsKey('meta')) {
            meta = Meta.fromJson(value.data['meta']);
          }
          else {
            meta = Meta.fromJson(value.data);
          }

          meta = meta.copyWith(status: (
              value.data is Map
                  && T.toString() != 'dynamic'
                  && ((value.data[key] is List && (value.data[key] as List).isEmpty) || value.data[key] == null
              ))
              ? Status.empty
              : Status.loaded);
        }
        else {
          meta = Meta.fromJson(value.data);
          meta = meta.copyWith(status: Status.loaded);
        }

        if(showSuccessMessage && method != Method.get) showMessage(meta);

        debugPrint("Dio Response:\nT is ${T.toString()}\nData is ${data.runtimeType.toString()}\nValue Data is ${value.data.runtimeType.toString()}\nMeta is ${meta.toString()}\nDeleted is $deleted");
        return Response<T>(data: data as T, deleted: deleted, meta: meta);

      }
      catch(e, stack) {
        debugPrint('Catch Error:\n$e\n$stack\n${T.toString()}\n$url');
        return Response<T>(
          meta: Meta(message: _errorMessage, status: Status.error),
        );
      }
    });
  } on d.DioException catch (e) {

    try {
      if(d.CancelToken.isCancel(e)) {
        meta = meta.copyWith(status: Status.cancelled);
      }
      else if(e.response != null) {
        if(redirectOnPermissionDenied && e.response!.statusCode == 401) {
          await clearAllLocalDataAndNavigate();
        }

        if(e.response!.data != null && e.response!.data is Map) {
          meta = Meta.fromJson(e.response!.data);
          meta = meta.copyWith(status: Status.error);
        }
      }
      else {
        meta = Meta(message: _errorMessage, status: Status.error);
      }

      debugPrint("Dio Error:${e.message}\nT is ${T.toString()}\nMeta is $meta");

      if(showErrorMessage && method != Method.get) showMessage(meta);

      return Response<T>(meta: meta);
    }
    catch(e, stack) {
      debugPrint('Catch Error:\n$e\n$stack\n${T.toString()}\n$url');

      return Response<T>(
          meta: Meta(message: _errorMessage, status: Status.error)
      );
    }
  }
}

showMessage(Meta meta) {
  showNotify(alert: fromAlertName(meta.type), message: meta.message);
}
