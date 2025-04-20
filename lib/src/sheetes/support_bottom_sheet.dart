import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
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
    onTap: () => _launchWhatsApp('775421110'),
    ),
    const SizedBox(height: 10),
    _buildSupportOption(
    context,
    icon: Icons.email_outlined,
    label: 'bookingguide999@gmail.com',
    onTap: () => _launchEmail('bookingguide999@gmail.com'),
    ),
]
    ),
    );
  }

  Widget _buildSupportOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Icon(icon, color: CustomTheme.primaryColor),
          ],
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

  void _launchWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
