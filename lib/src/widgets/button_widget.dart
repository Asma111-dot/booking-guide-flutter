import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/sizes.dart';

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
    final cs = Theme.of(context).colorScheme;
    final effectiveWidth = width.isFinite ? S.w(width) : width;

    return SizedBox(
      width: effectiveWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: Corners.pill100,
          gradient: disable ? null : CustomTheme.primaryGradient,
          color: disable ? cs.onSurface.withOpacity(0.12) : null,
        ),
        child: ElevatedButton(
          onPressed: disable ? null : () => onPressed?.call(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: cs.onPrimary,
            padding: EdgeInsets.symmetric(
              horizontal: Insets.m16,
              vertical: S.h(12),
            ),
            minimumSize: Sizes.btnM,
            shape: RoundedRectangleBorder(
              borderRadius: Corners.pill100,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: iconAfterText
                ? [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: TFont.l16,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimary,
                      ),
                    ),
                    if (icon != null) ...[
                      Gaps.w8,
                      IconTheme(
                        data: IconThemeData(color: cs.onPrimary),
                        child: icon!,
                      ),
                    ],
                  ]
                : [
                    if (icon != null) ...[
                      IconTheme(
                        data: IconThemeData(color: cs.onPrimary),
                        child: icon!,
                      ),
                      Gaps.w8,
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: TFont.l16,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
