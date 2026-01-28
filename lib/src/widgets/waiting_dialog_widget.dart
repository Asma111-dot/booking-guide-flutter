import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../utils/sizes.dart';

class WaitingDialogWidget extends StatelessWidget {
  const WaitingDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        padding: EdgeInsets.all(Insets.l20),
        margin: EdgeInsets.symmetric(horizontal: Insets.x2_32),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: Corners.md15,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: S.r(8),
              offset: Offset(0, S.h(3)),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            Gaps.h15,
            Text(
              trans().please_wait,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: TFont.l16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
