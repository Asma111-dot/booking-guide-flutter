import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../providers/auth/user_provider.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProvider.notifier).loadUserFromStorage();
    });
  }

  Future<void> _navigateToNextScreen() async {
    final firstTime = await isFirstTime();
    final loggedIn = isUserLoggedIn();

    if (firstTime || !loggedIn) {
      await setFirstTimeFalse();
      Navigator.pushReplacementNamed(context, Routes.login);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.navigationMenu,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.contain,
            child: Image.asset(mybooking),
          ),
        ],
      ),
    );
  }
}
