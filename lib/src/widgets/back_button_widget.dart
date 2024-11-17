import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'icon_button_widget.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.arrow = true, this.onPressed});

  final bool arrow;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) return const SizedBox(height: 0, width: 0);

    return IconButtonWidget(
      icon: arrow
          ? FontAwesomeIcons.arrowLeft
          : FontAwesomeIcons.times,
      onPressed: onPressed ??
          (Navigator.canPop(context)
              ? () => Navigator.maybePop(context)
              : () {}),
    );
  }
}
