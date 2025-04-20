import 'package:flutter/material.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../helpers/general_helper.dart';
import 'navigation_menu.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final firstTime = await isFirstTime();
    final loggedIn = isUserLoggedIn();

    if (firstTime || !loggedIn) {
      await setFirstTimeFalse();
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen(context);
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
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
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
