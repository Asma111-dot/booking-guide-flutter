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
        child: ValueListenableBuilder(
          valueListenable: date,
          builder: (context, value, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trans().select_availability_day,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.color2,
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
                      color: CustomTheme.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: CustomTheme.color2,
                    ),
                  ),
                  onTap: () async {
                    final picked = await showDialog<DateTime>(
                      context: context,
                      builder: (_) {
                        DateTime temp = date.value ?? today;
                        return AlertDialog(
                          title: Text(trans().select_date,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.color2,
                              )),
                          content: SizedBox(
                            height: 300,
                            child: dp.DayPicker.single(
                              selectedDate: temp,
                              onChanged: (d) => Navigator.of(context).pop(d),
                              firstDate: today,
                              lastDate: DateTime(2100),
                              datePickerStyles: dp.DatePickerRangeStyles(
                                selectedDateStyle:
                                    const TextStyle(color: Colors.white),
                                selectedSingleDateDecoration: BoxDecoration(
                                  color: CustomTheme.color2,
                                  shape: BoxShape.circle,
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
                ElevatedButton(
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
                  child: Text(
                    trans().apply_filter,
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
