import 'package:flutter/material.dart';

typedef OnAddressSelected = void Function(String value);

void showAddressNearUserBottomSheet({
  required BuildContext context,
  required OnAddressSelected onSelected,
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
            const Text('أدخل عنوانك الحالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final address = controller.text.trim();
                if (address.isNotEmpty) {
                  onSelected(address);
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
