import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';

typedef OnPriceSelected = void Function(String value);

void showPriceRangeBottomSheet({
  required BuildContext context,
  required OnPriceSelected onSelected,
}) {
  final minController = TextEditingController();
  final maxController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
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
            const Text('حدد نطاق السعر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: minController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'أقل سعر', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'أعلى سعر', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final min = toEnglishNumbers(minController.text.trim());
                final max = toEnglishNumbers(maxController.text.trim());
                if (min.isNotEmpty && max.isNotEmpty) {
                  onSelected('$min,$max');
                  Navigator.pop(context);
                }
              },
              child: const Text('تطبيق الفلترة'),
            ),
          ],
        ),
      );
    },
  );
}
