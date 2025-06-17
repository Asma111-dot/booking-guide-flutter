import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/display_mode.dart' as model;
import '../helpers/general_helper.dart';
import '../providers/public/settings_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

Widget buildDisplayModeToggle(WidgetRef ref, BuildContext context) {
  final settings = ref.watch(settingsProvider);
  final isDark = settings.displayMode == model.DisplayMode.dark;
  final icon = isDark ? darkModeIcon : lightModeIcon;

  return IconButton(
    onPressed: () {
      final notifier = ref.read(settingsProvider.notifier);
      notifier.setDisplayMode(
        isDark ? model.DisplayMode.light : model.DisplayMode.dark,
      );
    },
    icon: Icon(icon, color: CustomTheme.color2),
    tooltip: isDark ? trans().darkMode : trans().lightMode,
  );
}
