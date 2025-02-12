import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

class ShareButton extends StatelessWidget {
  final String textToShare;
  final String? subject;
  final double width;
  final bool iconAfterText;

  const ShareButton({
    Key? key,
    required this.textToShare,
    this.subject,
    this.width = 150,
    this.iconAfterText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          await Share.share(
            textToShare,
            subject: subject ?? trans().share,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: iconAfterText
              ? [
            Text(
              trans().share,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.share,
              size: 20,
              color: Colors.white,
            ),
          ]
              : [
            const Icon(
              Icons.share,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              trans().share,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
