import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import '../extensions/date_formatting.dart';
import '../utils/theme.dart';
import '../helpers/general_helper.dart';

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
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                    color: colorScheme.onSurface,
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
                      Icons.calendar_today,
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      if (date.value != null) {
                        onSelected(
                          convertToEnglishNumbers(
                            date.value!.toSqlDateOnly(),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text(trans().apply_filter),
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
