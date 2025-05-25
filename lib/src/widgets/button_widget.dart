import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Button extends StatelessWidget {
  final double width;
  final String title;
  final bool disable;
  final Future<void> Function()? onPressed;
  final Widget? icon;
  final bool iconAfterText;

  const Button({
    super.key,
    this.width = 150,
    required this.title,
    required this.onPressed,
    required this.disable,
    this.icon,
    this.iconAfterText = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = colorScheme.onPrimary;

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: CustomTheme.primaryGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ElevatedButton(
          onPressed: disable ? null : () => onPressed?.call(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: textColor,
            disabledForegroundColor: textColor.withOpacity(0.4),
            disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: iconAfterText
                ? [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                IconTheme(
                  data: IconThemeData(color: textColor),
                  child: icon!,
                ),
              ],
            ]
                : [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: textColor),
                  child: icon!,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
