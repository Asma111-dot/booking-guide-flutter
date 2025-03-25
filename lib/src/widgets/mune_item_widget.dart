import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../utils/theme.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData icon; // متغير جديد لتخزين الأيقونة

  const MenuItem({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.icon, // إضافة المتغير كوسيلة لتحديد الأيقونة
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomTheme.primaryColor.withOpacity(0.1),
        ),
        child: Icon(icon, color: CustomTheme.primaryColor), 
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodySmall),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomTheme.tertiaryColor.withOpacity(0.1),
        ),
        child: Icon(LineAwesomeIcons.angle_left_solid, color: CustomTheme.tertiaryColor),
      ),
    );
  }
}
