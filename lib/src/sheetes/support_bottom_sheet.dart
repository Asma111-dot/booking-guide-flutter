import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../utils/assets.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            trans().support,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            trans().support_message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          _buildSupportOption(
            context,
            icon: callIcon,
            label: '782006100',
            onTap: () => _launchPhone('782006100'),
          ),
          const SizedBox(height: 10),
          _buildSupportOption(
            context,
            icon: whatsappInIcon,
            label: '782006100',
            onTap: () => _launchWhatsApp(context, '782006100'),
          ),
          const SizedBox(height: 10),
          _buildSupportOption(
            context,
            icon: emailIcon,
            label: 'bookingguide999@gmail.com',
            onTap: () => _launchEmail(context, 'bookingguide999@gmail.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: colorScheme.primary.withOpacity(0.1),
        highlightColor: colorScheme.primary.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  fontFamily: 'Roboto',
                ),
              ),
              Icon(icon, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWhatsApp(BuildContext context, String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح واتساب. تأكد من أنه مثبت.')),
      );
    }
  }

  void _launchEmail(BuildContext context, String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=استفسار&body=مرحباً'),
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر فتح تطبيق البريد الإلكتروني.')),
      );
    }
  }
}
