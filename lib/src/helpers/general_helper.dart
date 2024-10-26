import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

import 'notify_helper.dart';

AppLocalizations trans() => AppLocalizations.of(navKey.currentContext!)!;

catchError(Object? e, StackTrace stack) {
  showNotify(
    alert: Alert.error,
    message: trans().checkYourInternetConnectionOrTryAgain,
  );
  debugPrint('Error:-\n${e.toString()}\n${stack.toString()}');
}

/// Find if 'value2' is higher than 'value1'
bool compareVersions(String current, String minimum) {

  try {
    // if versions are integers (e.g: 2)
    var currentVersion = int.parse(current);
    var minimumVersion = int.parse(minimum);

    if(minimumVersion <= currentVersion) return false;

    return true;
  }
  catch (e) {
    // if versions have dots (e.g: 2.0.1)
    bool isHigher = false;

    var currentVersion = current.split('.').map(int.parse).toList();
    var minimumVersion = minimum.split('.').map(int.parse).toList();

    for (var i = 0; i < currentVersion.length; i++) {
      if (currentVersion[i] > minimumVersion[i]) {
        break;
      }
      else if (currentVersion[i] < minimumVersion[i]) {
        isHigher = true;
        break;
      }
    }

    return isHigher;
  }
}

Future clearAllLocalDataAndNavigate() async {
  await clearCurrentUser();
  await clearSettings();

  Navigator.pushNamedAndRemoveUntil(navKey.currentContext!, Routes.login,
          (route) => false, arguments: true);
}

String convertArabicNumber(String value) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  String input = value;
  for (int i = 0; i < arabic.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }

  return input;
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}

Color? priceColor(BuildContext context) => Theme.of(context).colorScheme.primary;

String getMinutesFromSeconds(int value) {
  int minutes = Duration(seconds: value).inMinutes;
  int seconds = value - (minutes > 0 ? minutes * 60 : 0);

  return "$minutes:${seconds.toString().padLeft(2, "0")}";
}

int? convertToInt(dynamic value, {bool isNullable = true}) {
  try {
    var parse = int.tryParse(value?.toString() ?? '');
    return parse ?? (isNullable ? null : 0);
  }
  catch(e) {
    return isNullable ? null : 0;
  }
}

double? convertToDouble(dynamic value, {bool isNullable = true}) {
  try {
    var parse = double.tryParse(value?.toString() ?? '');
    return parse ?? (isNullable ? null : 0);
  }
  catch(e) {
    return isNullable ? null : 0;
  }
}

bool isTrue(dynamic value) {
  return [true,'true',1,'1'].contains(value ?? '');
}

Future pickImage({
  required image_picker.ImageSource source,
  required void Function(File file) onSuccess,
}) async {
  await image_picker.ImagePicker().pickImage(
    source: source,
    imageQuality: 80,
  ).then((pickedImage) {
    if (pickedImage != null) {
      onSuccess(File(pickedImage.path));
    }
  });
}

bool isNumber(String? value) {
  if (value == null) {
    return false;
  }
  return (double.tryParse(value) is double) ? true : false;
}