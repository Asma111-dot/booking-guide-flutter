import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:booking_guide/src/extensions/theme_extension.dart';

import '../utils/theme.dart';

class ChipWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? lottieAsset;
  final double? lottieHeight;

  const ChipWidget({
    super.key,
    required this.child,
    this.onPressed,
    this.lottieAsset,
    this.lottieHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme(isDark: Theme.of(context).isDark());

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: theme.lightBackgroundColor(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                height: lottieHeight ?? 24.0,
                repeat: true,
              ),
            if (lottieAsset != null) const SizedBox(width: 4.0),
            child,
          ],
        ),
      ),
    );
  }
}