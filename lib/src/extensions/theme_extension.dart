import 'package:flutter/material.dart';

import '../utils/routes.dart';
import '../utils/theme.dart';

extension ThemeExtension on ThemeData {

  bool isDark() {
    return Theme.of(navKey.currentContext!).colorScheme.brightness == Brightness.dark;
  }

  bool isLight() {
    return Theme.of(navKey.currentContext!).colorScheme.brightness == Brightness.light;
  }

  Color successColor() => CustomTheme(isDark: isDark()).successColor();

  Color dangerColor() => CustomTheme(isDark: isDark()).dangerColor();

  Color warningColor() => CustomTheme(isDark: isDark()).warningColor();

  Color progressColor() => CustomTheme(isDark: isDark()).progressColor();

  Color borderColor() => CustomTheme(isDark: isDark()).borderColor();

  Color lightBackgroundDarkColor() => CustomTheme(isDark: isDark()).lightBackgroundColor();
}
