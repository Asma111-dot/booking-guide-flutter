import 'package:bot_toast/bot_toast.dart';
import 'package:booking_guide/src/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

import '../enums/alert.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/loading_widget.dart';

export '../enums/alert.dart';

void showNotify({
  Alert? alert,
  String? message,
  Alignment alignment = Alignment.topCenter,
}) {
  if(message?.isEmpty ?? true) return;

  BotToast.showSimpleNotification(
    title: message!,
    align: alignment,
    borderRadius: CustomTheme.radius,
    hideCloseButton: _getIcon(alert) == null,
    closeIcon: Icon(_getIcon(alert),
      color: _getColor(alert),
    ),
    backgroundColor: Theme.of(navKey.currentContext!).colorScheme.tertiary,
    titleStyle: TextStyle(
      color: Theme.of(navKey.currentContext!).colorScheme.onTertiary,
    ),
    duration: const Duration(seconds: 3),
  );
}

void showLoading() {
  BotToast.showCustomLoading(
    toastBuilder: (_) => const LoadingWidget(),
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