import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';
import '../enums/alert.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/waiting_dialog_widget.dart';

export '../enums/alert.dart';

// void showNotify({
//   Alert? alert,
//   String? message,
//   Alignment alignment = Alignment.topCenter,
// })
// {
//   if(message?.isEmpty ?? true) return;
//
//   BotToast.showSimpleNotification(
//     title: message!,
//     align: alignment,
//     borderRadius: CustomTheme.radius,
//     hideCloseButton: _getIcon(alert) == null,
//     closeIcon: Icon(_getIcon(alert),
//       color: _getColor(alert),
//     ),
//     backgroundColor: Theme.of(navKey.currentContext!).colorScheme.primary,
//     titleStyle: TextStyle(
//       color: Theme.of(navKey.currentContext!).colorScheme.primaryFixed,
//     ),
//     duration: const Duration(seconds: 5),
//   );
// }
void showNotify({
  Alert? alert,
  String? message,
  Alignment alignment = Alignment.topCenter,
}) {
  if (message?.isEmpty ?? true) return;

  BotToast.showSimpleNotification(
    title: message!,
    align: alignment,
    borderRadius: CustomTheme.radius,
    hideCloseButton: _getIcon(alert) == null,
    closeIcon: Icon(_getIcon(alert), color: Colors.white),
    backgroundColor: _getBackgroundColor(alert),
    titleStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    duration: const Duration(seconds: 5),
  );
}

void showLoading() {
  BotToast.showCustomLoading(
    toastBuilder: (_) => const WaitingDialogWidget(),
    ignoreContentClick: true,
    backButtonBehavior: BackButtonBehavior.ignore,
  );
}

void hideLoading() {
  BotToast.closeAllLoading();
}

Color? _getColor(Alert? alert) {
  switch(alert) {
    case Alert.success:
      return Theme.of(navKey.currentContext!).successColor();
    case Alert.warning:
      return Theme.of(navKey.currentContext!).warningColor();
    case Alert.error:
      return Theme.of(navKey.currentContext!).dangerColor();
    case Alert.info:
      return Theme.of(navKey.currentContext!).colorScheme.primary;
    default:
      return null;
  }
}

IconData? _getIcon(Alert? alert) {
  switch(alert) {
    case Alert.success:
      return Icons.check_circle_rounded;
    case Alert.warning:
      return Icons.warning_rounded;
    case Alert.error:
      return Icons.error_rounded;
    case Alert.info:
      return Icons.info_rounded;
    default:
      return null;
  }
}
Color _getBackgroundColor(Alert? alert) {
  final isDark = Theme.of(navKey.currentContext!).isDark();
  final theme = CustomTheme(isDark: isDark);

  switch (alert) {
    case Alert.success:
      return theme.successColor();
    case Alert.error:
      return theme.dangerColor();
    case Alert.warning:
      return theme.warningColor();
    case Alert.info:
      return theme.progressColor();
    default:
      return theme.progressColor();
  }
}
