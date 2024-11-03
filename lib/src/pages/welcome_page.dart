import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../helpers/general_helper.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen(context);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              logoCoverImage,
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'مرحباً بك في دليل الحجوزات',
              // "${trans().welcome} ${trans().to} ${trans().appTitle}",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'وجهتك النهائية للحجوزات',
              // trans().ultimateDestination,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
