import 'package:flutter/material.dart';
import '../utils/routes.dart';

Future<bool> confirmExitToHome(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تأكيد الخروج'),
      content: const Text('هل تريد العودة إلى الصفحة الرئيسية؟'),
      actions: [
        TextButton(
          child: const Text('لا'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('نعم'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );

  if (result == true) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.navigationMenu,
          (route) => false,
    );
    return true;
  }

  return false;
}
