import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String message;
  final bool isEmpty;
  final bool textOnly;
  final double? height;
  final Widget? headerWidget;
  final VoidCallback? onTap;
  final String? lottieAnimation;

  const ErrorMessageWidget({
    Key? key,
    this.message = 'An error occurred.',
    this.isEmpty = false,
    this.textOnly = false,
    this.height,
    this.headerWidget,
    this.onTap,
    this.lottieAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (headerWidget != null) headerWidget!,
          if (!textOnly)
            Lottie.asset(
              lottieAnimation ?? (isEmpty ? emptyJson : errorJson),
              width: 120,
              height: 120,
              repeat: false,
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
    );
  }
}
