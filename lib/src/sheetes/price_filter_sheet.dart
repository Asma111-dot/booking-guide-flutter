import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';
import '../utils/theme.dart';

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
              style: const TextStyle(fontFamily: 'Roboto'),
              decoration: InputDecoration(
                labelText: trans().min_price,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',

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
              style: const TextStyle(fontFamily: 'Roboto'),
              decoration: InputDecoration(
                labelText: trans().max_price,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
                      final min = convertToEnglishNumbers(minController.text.trim());
                      final max = convertToEnglishNumbers(maxController.text.trim());
                      if (min.isNotEmpty && max.isNotEmpty) {
                        onSelected('$min,$max');
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
