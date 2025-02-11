import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomCalendarWidget extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  final DateTime? initialSelectedDay;
  final Function(DateTime selectedDate) onDateSelected;

  const CustomCalendarWidget({
    Key? key,
    required this.events,
    this.initialSelectedDay,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialSelectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: SfDateRangePicker(
        backgroundColor: Colors.white,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        showTodayButton: false,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (args) async {
          final selectedDate = args.value as DateTime;

          if (widget.events[selectedDate]?.isNotEmpty ?? false) {
            _showDateBookedMessage(context);
          } else {
            setState(() {
              selectedDay = selectedDate;
            });
            widget.onDateSelected(selectedDate);

          }
        },
        monthViewSettings: DateRangePickerMonthViewSettings(
          dayFormat: 'E',
          specialDates: widget.events.keys.toList(),
          showTrailingAndLeadingDates: false,
          weekendDays: <int>[DateTime.tuesday, DateTime.friday],
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          specialDatesTextStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.lineThrough,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showDateBookedMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("عذرا!!"),
          content: const Text("هذا اليوم محجوز بالفعل، الرجاء اختيار يوم آخر."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("حسنًا"),
            ),
          ],
        );
      },
    );
  }
}
