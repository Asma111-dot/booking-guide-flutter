import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/assets.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final bool useLottie;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.useLottie = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: useLottie
          ? Lottie.asset(
        unauthorizedJson,
        width: size ?? 24.0,
        height: size ?? 24.0,
        repeat: false,
      )
          : Icon(
        icon,
        color: color ?? Theme.of(context).iconTheme.color,
        size: size ?? 24.0,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}
