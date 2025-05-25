import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../helpers/general_helper.dart';

enum DisplayMode {systemDefault, light, dark}

DisplayMode displayModeFromName(String name) =>
    DisplayMode.values.firstWhere((element) => element.name == name);

extension DisplayFormatting on DisplayMode {
  bool isDark() {
    switch(this) {
      case DisplayMode.light:
        return false;
      case DisplayMode.dark:
        return true;
      default:
        return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
  }

  String toDarkNaming() {
    switch(this) {
      case DisplayMode.light:
        return trans().off;
      case DisplayMode.dark:
        return trans().on;
      default:
        return trans().usingSystemSettings;
    }
  }

  String toName() {
    switch(this) {
      case DisplayMode.light:
        return trans().lightMode;
      case DisplayMode.dark:
        return trans().darkMode;
      default:
        return trans().usingSystemSettings;
    }
  }
}
