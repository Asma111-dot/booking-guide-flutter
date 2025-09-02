import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/sizes.dart';

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
    final colors = theme.colorScheme;

    return ListTile(
      onTap: onPressed,
      contentPadding: EdgeInsets.symmetric(horizontal: Insets.xs8),
      leading: Container(
        width: S.w(40),
        height: S.h(40),
        decoration: BoxDecoration(
          color: colors.secondary.withOpacity(0.1),
          borderRadius: Corners.pill100,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: colors.primary, size: Sizes.iconM20),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: TFont.s12,
          color: colors.secondary,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
        subtitle!,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: TFont.xxs10,
          color: colors.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Directionality.of(context) == TextDirection.rtl
            ? angleLeftIcon
            : angleRightIcon,
        color: colors.primary,
        size: Sizes.iconM20,
      ),
    );
  }
}
