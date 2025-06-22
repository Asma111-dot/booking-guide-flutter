import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/general_helper.dart';

typedef OnCapacitySelected = void Function(String value);

void showCapacityBottomSheet({
  required BuildContext context,
  required OnCapacitySelected onSelected,
}) {
  final controller = TextEditingController();
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

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
              trans().select_people_count,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: trans().people_count,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: () {
                  final value = convertToEnglishNumbers(controller.text.trim());
                  if (value.isNotEmpty) {
                    onSelected(value);
                    Navigator.pop(context);
                  }
                },
                child: Text(trans().apply_filter),
              ),
            ),
          ],
        ),
      );
    },
  );
}
