import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';
import '../utils/routes.dart';

Future<bool> confirmExitToHome(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(trans().confirmExitTitle),
      content: Text(trans().confirmExitMessage),
      actions: [
        TextButton(
          child: Text(trans().no),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(trans().yes),
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
