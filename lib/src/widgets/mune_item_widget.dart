import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../utils/theme.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onPressed;
  final IconData icon;

  const MenuItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomTheme.primaryColor.withValues(alpha: 0.1 * 255),
        ),
        child: Icon(icon, color: CustomTheme.color2),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: CustomTheme.primaryColor
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
          fontSize: 11,
        ),
      )
          : null,
      trailing: SizedBox(
        width: 30,
        height: 30,
        child: Icon(LineAwesomeIcons.angle_left_solid,
            color: CustomTheme.color2, size: 18),
      ),
    );
  }
}
