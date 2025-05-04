import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../helpers/general_helper.dart';
import '../pages/navigation_menu.dart';
import '../providers/auth/user_provider.dart';
import '../utils/theme.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).loadUserFromStorage();
      _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final firstTime = await isFirstTime();
    final loggedIn = isUserLoggedIn();

    if (firstTime || !loggedIn) {
      await setFirstTimeFalse();
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationMenu()),
      );]
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.white],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              "${trans().welcomeToBooking} ....",
              style: const TextStyle(
                fontSize: 24,
                color: CustomTheme.color2,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              booking,
              width: 150,
              height: 150,
            ),

            const SizedBox(height: 20),
            Text(
              trans().ultimateDestination,
              style: const TextStyle(
                fontSize: 16,
                color: CustomTheme.color4,
              ),
            ),
            const SizedBox(height: 40),
            // const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
