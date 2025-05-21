import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets.dart';
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
    final unauthorizedMessage = message.isEmpty ? trans().unauthorizedMessage : message;

    return Container(
      height: height ?? 200,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            unauthorizedJson,
            width: 120,
            height: 120,
            repeat: false,
          ),
          const SizedBox(height: 16.0),
          Text(
            unauthorizedMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(trans().login),
          ),
        ],
      ),
    );
  }
}
