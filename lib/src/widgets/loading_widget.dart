import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? size;

  const LoadingWidget({super.key, this.height, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: size,
      child: Center(
        child: Lottie.asset(loadingJson, width: size ?? 100, height: size ?? 100),
      ),
    );
  }
}
