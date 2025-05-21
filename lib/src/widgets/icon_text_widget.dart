import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../extensions/theme_extension.dart'; // Ensure you have this extension

import '../utils/assets.dart';
import '../utils/theme.dart';

class IconTextWidget extends StatelessWidget {
  final IconData? icon;
  final String? lottieAsset;
  final String text;
  final Color? color;
  final double? textSize;
  final bool useLottie;

  const IconTextWidget({
    super.key,
    this.icon,
    this.lottieAsset,
    required this.text,
    this.color,
    this.textSize,
    this.useLottie = false,
  });

  @override
  Widget build(BuildContext context) {
    var theme = CustomTheme(isDark: Theme.of(context).brightness == Brightness.dark); // Determine theme state

    return Row(
      children: [
        if (useLottie && lottieAsset != null)
          Lottie.asset(
            lottieAsset!,
            width: 24.0,
            height: 24.0,
            repeat: false,
          )
        else if (icon != null)
          Icon(
            icon,
            color: color ?? theme.borderColor(), // Use color from CustomTheme
            size: 24.0,
          ),
        SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            color: color ?? theme.lightBackgroundColor(), // Use color from CustomTheme
            fontSize: textSize ?? 14.0,
          ),
        ),
      ],
    );
  }
}
