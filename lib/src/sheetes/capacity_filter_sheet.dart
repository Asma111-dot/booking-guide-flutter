import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/general_helper.dart';

typedef OnCapacitySelected = void Function(String value);

void showCapacityBottomSheet({
  required BuildContext context,
  required OnCapacitySelected onSelected,
}) {
  final controller = TextEditingController();

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
            const Text('حدد عدد الأشخاص', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'عدد الأشخاص', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final value = toEnglishNumbers(controller.text.trim());
                if (value.isNotEmpty) {
                  onSelected(value);
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
