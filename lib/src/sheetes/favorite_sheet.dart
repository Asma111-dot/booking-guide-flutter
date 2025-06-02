import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

void showRemoveFavoriteSheet(
    BuildContext context, {
      required VoidCallback onConfirm,
    }) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    backgroundColor: colorScheme.background,
    builder: (_) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Icon(
            Icons.warning_amber_rounded,
            size: 30,
            color: colorScheme.onSurface,
          ),
          const SizedBox(height: 15),
          Text(
            trans().remove_from_favorites_confirm,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                Navigator.pop(context); // إغلاق الشيت أولًا
                onConfirm(); // تنفيذ الإزالة
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: CustomTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      trans().verify,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
