import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';

typedef OnPriceSelected = void Function(String value);

void showPriceRangeBottomSheet({
  required BuildContext context,
  required OnPriceSelected onSelected,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final minController = TextEditingController();
  final maxController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trans().select_price_range,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: trans().min_price,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              style: const TextStyle( // 👈 هنا أضفنا هذا السطر
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
              decoration: InputDecoration(
                labelText: trans().max_price,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final min = convertToEnglishNumbers(minController.text.trim());
                final max = convertToEnglishNumbers(maxController.text.trim());
                if (min.isNotEmpty && max.isNotEmpty) {
                  onSelected('$min,$max');
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(trans().apply_filter),
            ),
          ],
        ),
      );
    },
  );
}
