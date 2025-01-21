import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.width,
    required this.title,
    required this.onPressed,
    required this.disable,
    this.icon,
    this.iconAfterText = false,
  }) : super(key: key);

  final double width;
  final String title;
  final bool disable;
  final Future<void> Function()? onPressed;
  final Widget? icon;
  final bool iconAfterText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomTheme.primaryColor,
          foregroundColor: CustomTheme.placeholderColor,
        ),
        onPressed: disable ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: iconAfterText
              ? [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              icon!,
            ],
          ]
              : [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
