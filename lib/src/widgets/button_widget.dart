import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.width,
    required this.title,
    required this.onPressed,
    required this.disable,
    this.icon,
    this.iconAfterText = false,
  });

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
      child: InkWell(
        onTap: disable ? null : () => onPressed?.call(),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: CustomTheme.primaryGradient,
            borderRadius: BorderRadius.circular(30),
          ),
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
                  color: Colors.white,
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
                style:  TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
