import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/general_helper.dart';
import '../utils/theme.dart';

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
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          top: 16,
          bottom: bottomInset + 8,
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trans().select_people_count,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.color3,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: controller,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: 'Roboto'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: trans().people_count,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: CustomTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          final value = convertToEnglishNumbers(controller.text.trim());
                          if (value.isNotEmpty) {
                            onSelected(value);
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
          ),
        ),
      );
    },
  );
}
