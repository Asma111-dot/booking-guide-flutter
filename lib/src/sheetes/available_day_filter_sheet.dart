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
                const Text('حدد يوم التوفر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'اختر التاريخ',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final picked = await showDialog<DateTime>(
                      context: context,
                      builder: (_) {
                        DateTime temp = date.value ?? today;
                        return AlertDialog(
                          title: const Text('اختر التاريخ'),
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
                                  color: CustomTheme.primaryColor,
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
                      onSelected(toEnglishNumbers(date.value!.toSqlDateOnly()));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('تطبيق الفلترة'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
