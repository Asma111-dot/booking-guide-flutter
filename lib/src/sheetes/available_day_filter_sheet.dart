import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import '../extensions/date_formatting.dart';
import '../utils/assets.dart';
import '../helpers/general_helper.dart';
import '../utils/theme.dart';

typedef OnDaySelected = void Function(String value);

void showAvailableDayBottomSheet({
  required BuildContext context,
  required OnDaySelected onSelected,
}) {
  final date = ValueNotifier<DateTime?>(null);
  final controller = TextEditingController();
  final today = DateTime.now();
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
      final bottomPad = MediaQuery.of(context).padding.bottom;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          top: 16,
          bottom: bottomPad,
        ),
        child: ValueListenableBuilder(
          valueListenable: date,
          builder: (context, value, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trans().select_availability_day,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.color3,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: trans().select_date,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: Icon(
                      periodIcon,
                      color: colorScheme.secondary,
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDialog<DateTime>(
                      context: context,
                      builder: (_) {
                        DateTime temp = date.value ?? today;
                        return AlertDialog(
                          backgroundColor: colorScheme.background,
                          title: Text(
                            trans().select_date,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          content: SizedBox(
                            height: 300,
                            child: dp.DayPicker.single(
                              selectedDate: temp,
                              onChanged: (d) => Navigator.of(context).pop(d),
                              firstDate: today,
                              lastDate: DateTime(2100),
                              datePickerStyles: dp.DatePickerRangeStyles(
                                selectedDateStyle: const TextStyle(color: Colors.white),
                                selectedSingleDateDecoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  shape: BoxShape.circle,
                                ),
                                dayHeaderStyle: dp.DayHeaderStyle(
                                  textStyle: TextStyle(color: colorScheme.onSurface),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    if (picked != null) {
                      date.value = picked;
                      controller.text = picked.toSqlDateOnly();
                    }
                  },
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
                          if (date.value != null) {
                            onSelected(
                              convertToEnglishNumbers(
                                date.value!.toSqlDateOnly(),
                              ),
                            );
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
            );
          },
        ),
      );
    },
  );
}
