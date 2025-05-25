import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colorScheme.secondary.withOpacity(0.1),
        ),
        child: Icon(icon, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: colorScheme.primary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle!,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: colorScheme.onSurface.withOpacity(0.6),
        ),
      )
          : null,
      trailing: Icon(
        LineAwesomeIcons.angle_left_solid,
        color: colorScheme.primary,
        size: 20,
      ),
    );
  }
}
