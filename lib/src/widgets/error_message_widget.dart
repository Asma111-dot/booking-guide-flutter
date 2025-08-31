import 'package:flutter/material.dart';

import '../utils/sizes.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final bool isEmpty;
  final bool textOnly;
  final double? height;
  final Widget? headerWidget;
  final VoidCallback? onTap;
  final IconData? errorIcon;

  const ErrorMessageWidget({
    super.key,
    this.message = 'An error occurred.',
    this.isEmpty = false,
    this.textOnly = false,
    this.height,
    this.headerWidget,
    this.onTap,
    this.errorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(Insets.m16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (headerWidget != null) headerWidget!,
            if (!textOnly)
              Icon(
                errorIcon,
                size: S.r(120),
                color: isEmpty ? Colors.grey : Colors.red,
              ),
            Gaps.h15,
            Text(
              message,
              style: TextStyle(
                color: isEmpty ? Colors.grey : Colors.red,
                fontSize: TFont.l16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (onTap != null) ...[
              Gaps.h15,
              ElevatedButton(
                onPressed: onTap,
                child: Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
