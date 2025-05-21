import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

late StreamSubscription<List<ConnectivityResult>> subscription;
ValueNotifier<List<ConnectivityResult>> connectivityResult = ValueNotifier([ConnectivityResult.none]);

class ConnectivityService extends ChangeNotifier {

  static init() {
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      connectivityResult.value = results;
      connectivityResult.notifyListeners();
    });
  }

  static Future<bool> isConnected() async {
    return Connectivity().checkConnectivity()
        .then((result) => result
        .any((e) => e == ConnectivityResult.wifi || e == ConnectivityResult.mobile));
  }

  static Future<bool> isDisconnected() async {
    return !await isConnected();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}














