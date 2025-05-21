import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (headerWidget != null) headerWidget!,
            if (!textOnly)
              Icon(
                errorIcon ?? Icons.error,
                size: 120,
                color: isEmpty ? Colors.grey : Colors.red,
              ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(
                color: isEmpty ? Colors.grey : Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (onTap != null) ...[
              const SizedBox(height: 16.0),
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
