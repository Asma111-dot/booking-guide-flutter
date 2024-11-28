import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../helpers/general_helper.dart';
import '../utils/theme.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    final box = await Hive.openBox('auth');
    final isFirstVisit = box.get('isFirstVisit', defaultValue: true);

    if (isFirstVisit) {
      await box.put('isFirstVisit', false);
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushReplacementNamed(context, Routes.facilityTypes);
    }
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
            colors: [CustomTheme.primaryColor, Colors.lightBlueAccent],
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
              "${trans().welcome} ${trans().to} ${trans().appTitle}",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              trans().ultimateDestination,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
