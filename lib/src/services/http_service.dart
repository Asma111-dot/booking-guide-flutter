import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/auth_storage.dart';
import '../storage/settings_storage.dart';
import '../utils/global.dart';
import '../utils/urls.dart';
import 'app_service.dart';

class HttpService {

  // Singleton pattern instance
  static final HttpService _httpService = HttpService._internal();
  HttpService._internal();
  static HttpService get instance => _httpService;

  // Members
  static Dio? _dio;
  Dio get dio {
    if(_dio != null) return _dio!;

    _dio = _initDio();
    setDefaultHeaders();
    return _dio!;
  }

  Dio _initDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-IS-DEBUG': kDebugMode,
          'X-NOOT-AUTH-TOKEN': authToken,
          'Accept-Language': getSettings().languageCode,
          'Authorization': 'Bearer ${getToken()}',
        },
      ),
    )..interceptors.addAll(
      [
        if (kDebugMode)
          LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: true,
            error: true,
          ),
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            options.headers.addAll({
              'Authorization': 'Bearer ${getToken()}',
            });
            return handler.next(options);
          },
        ),
      ],
    );

    return dio;
  }

  // Call it on first request
  Future setDefaultHeaders() async {
    String? firebaseToken;

    try {
      // NotificationService.token().then((value) {
      //   firebaseToken = value;
      //   debugPrint('FirebaseToken: $firebaseToken');
      // });
    } catch (e) {}

    final device = await deviceInfo();
    final package = await packageInfo();
    // final signature = await SmsAutoFill().getAppSignature;

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers.addAll({
            if (device is AndroidDeviceInfo) ...{
              'X-DEVICE-ID': device.fingerprint,
              'X-DEVICE-BRAND': device.brand,
              'X-DEVICE-MODEL': device.model,
              'X-DEVICE-OS': 'android',
              'X-DEVICE-OS-VERSION': device.version.release,
              'X-DEVICE-IS-PHYSICAL': device.isPhysicalDevice,
              // 'X-DEVICE-SIGNATURE': signature,
            } else if (device is IosDeviceInfo) ...{
              'X-DEVICE-ID': device.identifierForVendor,
              'X-DEVICE-BRAND': 'apple',
              'X-DEVICE-MODEL': device.model,
              'X-DEVICE-OS': 'ios',
              'X-DEVICE-OS-VERSION': device.systemVersion,
              'X-DEVICE-IS-PHYSICAL': device.isPhysicalDevice,
            },
            'X-PACKAGE-NAME': package.packageName,
            'X-PACKAGE-VERSION': package.version,
            'X-PACKAGE-BUILD-NUMBER': package.buildNumber,
          });
          return handler.next(options);
        },
      ),
    ]);
  }
}
