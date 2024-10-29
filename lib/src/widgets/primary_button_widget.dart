import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool loading;

  const PrimaryButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: loading
          ?
      Lottie.asset(loadingJson)
          :
      FilledButton(
        onPressed: loading ? () {} : onPressed,
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}