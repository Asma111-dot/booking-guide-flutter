import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/general_helper.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../storage/auth_storage.dart';
import '../utils/routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  int index = 0;

  final pages =  [
    _OnbItem(
      png: onboard1Png,
      subtitle: trans().onboarding1_subtitle,
    ),
    _OnbItem(
      png: onboard2Png,
      subtitle: trans().onboarding2_subtitle,
    ),
    _OnbItem(
      png: onboard3Png,
      subtitle: trans().onboarding3_subtitle,
    ),
  ];

  Future<void> _finish() async {
    await setFirstTimeFalse();
    final loggedIn = isUserLoggedIn();
    if (loggedIn) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.navigationMenu, (_) => false);
    } else {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark, // للـ iOS
      ),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => index = i),
                  itemBuilder: (_, i) => pages[i],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 20, top: 8),
                child: Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: TextButton(
                    onPressed: _finish,
                    child: const Text('تخطي'),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  final active = i == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: active ? 22 : 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: active ? CustomTheme.primaryGradient : null,
                      color: active ? null : cs.outlineVariant.withOpacity(.6),
                    ),
                  );
                }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (index == pages.length - 1) {
                        _finish();
                      } else {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: CustomTheme.primaryGradient,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Center(
                          child: Text(
                            index == pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnbItem extends StatelessWidget {
  final String png;
  final String subtitle;

  const _OnbItem({
    required this.png,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.55,
              child: Image.asset(
                png,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            const SizedBox(height: 30),

            // الوصف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cs.onSurface.withOpacity(.75),
                  fontSize: 15,
                  height: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
