import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../extensions/theme_extension.dart';
import '../utils/theme.dart';
import '../utils/sizes.dart';

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
          borderRadius: Corners.sm8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Insets.xs8,
          vertical: Insets.xxs6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                height: lottieHeight ?? S.h(24),

                repeat: true,
              ),
            if (lottieAsset != null) Gaps.w4,

            child,
          ],
        ),
      ),
    );
  }
}
