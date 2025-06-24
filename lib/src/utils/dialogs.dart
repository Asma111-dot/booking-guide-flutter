import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';

void showWaitingDialog(BuildContext context, void Function(BuildContext dialogCtx) onReady) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      // 🔥 استدعِ الدالة عند بناء السياق
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onReady(dialogCtx);
      });

      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                trans().please_wait,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
