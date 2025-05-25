import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

class SupportBottomSheet extends StatelessWidget {
  const SupportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
                    color: CustomTheme.color2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              trans().support_message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            _buildSupportOption(
              context,
              icon: Icons.phone,
              label: '775421110',
              onTap: () => _launchPhone('775421110'),
            ),
            const SizedBox(height: 10),
            _buildSupportOption(
              context,
              icon: FontAwesomeIcons.whatsapp,
              label: '775421110',
              onTap: () => _launchWhatsApp(context, '775421110'),
            ),
            const SizedBox(height: 10),
            _buildSupportOption(
              context,
              icon: Icons.email_outlined,
              label: 'bookingguide999@gmail.com',
              onTap: () => _launchEmail(context, 'bookingguide999@gmail.com'),
            ),
          ]),
    );
  }

  Widget _buildSupportOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: CustomTheme.color2.withOpacity(0.1),
        highlightColor: CustomTheme.color2.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Icon(icon, color: CustomTheme.color2),
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
