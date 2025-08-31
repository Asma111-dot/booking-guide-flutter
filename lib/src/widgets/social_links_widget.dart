import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';

class SocialLinksWidget extends StatelessWidget {
  const SocialLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [CustomTheme.color1, CustomTheme.color4],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: IconButton(
            icon: Icon(instagramIcon, size: Sizes.iconL36, color: Colors.white),
            tooltip: 'تابعنا على إنستغرام',
            onPressed: () => _launchSocialLink(
              context,
              'https://www.instagram.com/invites/contact/?igsh=1x7b8sqt4ehtf&utm_content=ntdv6km',
              'تعذر فتح إنستغرام. تأكد من أنه مثبت.',
            ),
          ),
        ),
        Gaps.w12,
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [CustomTheme.color1, CustomTheme.color4],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: IconButton(
            icon: Icon(facebookIcon, size: Sizes.iconL36, color: Colors.white),
            tooltip: 'تابعنا على فيسبوك',
            onPressed: () => _launchSocialLink(
              context,
              'https://www.facebook.com/profile.php?id=100068967492740&mibextid=rS40aB7S9Ucbxw6v',
              'تعذر فتح فيسبوك. تأكد من أنه مثبت.',
            ),
          ),
        ),
      ],
    );
  }

  void _launchSocialLink(BuildContext context, String url, String errorMessage) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched) {
        // fallback or error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء فتح الرابط.')),
      );
    }
  }
}
