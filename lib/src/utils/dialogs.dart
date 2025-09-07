import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';

void showWaitingDialog(
    BuildContext context, void Function(BuildContext dialogCtx) onReady) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
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
                trans().please_wait.replaceAll('<u>', '').replaceAll('</u>', ''),
                style:  TextStyle(decoration: TextDecoration.none,
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
