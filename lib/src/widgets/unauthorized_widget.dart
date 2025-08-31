import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../helpers/general_helper.dart';

class UnauthorizedWidget extends StatelessWidget {
  final String message;
  final double? height;

  const UnauthorizedWidget({
    super.key,
    this.message = '',
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final unauthorizedMessage =
    message.isEmpty ? trans().unauthorizedMessage : message;

    return Container(
      height: height ?? S.h(200),
      padding: EdgeInsets.all(Insets.m16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            unauthorizedJson,
            width: S.w(120),
            height: S.h(120),
            repeat: false,
          ),
          Gaps.h15,
          Text(
            unauthorizedMessage,
            style: TextStyle(
              color: Colors.red,
              fontSize: TFont.l16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Gaps.h15,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.l20,
                vertical: S.h(12),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: Corners.md15,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              trans().login,
              style: TextStyle(fontSize: TFont.m14),
            ),
          ),
        ],
      ),
    );
  }
}
