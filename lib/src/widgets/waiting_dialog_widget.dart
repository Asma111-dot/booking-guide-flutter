import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';

class WaitingDialogWidget extends StatelessWidget {
  const WaitingDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 48),
        decoration: BoxDecoration(
          color: colorScheme.surface,
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
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
