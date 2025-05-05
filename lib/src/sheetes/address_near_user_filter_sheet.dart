import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

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
            Text(
              trans().enter_current_address,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: CustomTheme.color2,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: trans().address,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColor,
                ),
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
              child: Text(
                trans().apply_filter,
              ),
            ),
          ],
        ),
      );
    },
  );
}
