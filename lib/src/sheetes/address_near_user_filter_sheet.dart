import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

typedef OnAddressSelected = void Function(String value);

void showAddressNearUserBottomSheet({
  required BuildContext context,
  required OnAddressSelected onSelected,
}) {
  final controller = TextEditingController();
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final mq = MediaQuery.of(context);
      final bottomPad = mq.viewInsets.bottom > 0 ? mq.viewInsets.bottom : mq.padding.bottom;

      return Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: bottomPad,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trans().enter_current_address,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CustomTheme.color3,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: false,
              decoration: InputDecoration(
                labelText: trans().address,
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
              child: Material(
                color: Colors.transparent,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: CustomTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final address = controller.text.trim();
                      if (address.isNotEmpty) {
                        onSelected(address);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        trans().apply_filter,
                        style: const TextStyle(
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
      );
    },
  );
}
