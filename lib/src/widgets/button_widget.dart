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
    final cs = Theme.of(context).colorScheme;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 4),
        child: SizedBox(
          width: width.isFinite ? width : double.infinity,
          height: 48,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),

            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: disable ? null : () => onPressed?.call(),

              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  gradient: disable
                      ? null
                      : CustomTheme.primaryGradient,

                  color: disable
                      ? Colors.grey.shade300
                      : null,
                ),

                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: iconAfterText
                        ? [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: disable
                              ? Colors.grey.shade600
                              : cs.onPrimary,
                        ),
                      ),

                      if (icon != null) ...[
                        const SizedBox(width: 8),
                        IconTheme(
                          data: IconThemeData(
                            color: disable
                                ? Colors.grey.shade600
                                : cs.onPrimary,
                          ),
                          child: icon!,
                        ),
                      ],
                    ]
                        : [
                      if (icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: disable
                                ? Colors.grey.shade600
                                : cs.onPrimary,
                          ),
                          child: icon!,
                        ),
                        const SizedBox(width: 8),
                      ],

                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: disable
                              ? Colors.grey.shade600
                              : cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
