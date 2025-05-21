import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/theme.dart';

enum SelectionType { single, range }

class CustomCalendarWidget extends StatefulWidget {
  final Map<DateTime, List<String>> events;
  final SelectionType selectionType;
  final DateTime? initialSelectedDay;
  final DateTimeRange? initialSelectedRange;
  final Function(DateTime selectedDate)? onSingleDateSelected;
  final Function(DateTimeRange selectedRange)? onRangeSelected;

  const CustomCalendarWidget({
    super.key,
    required this.events,
    required this.selectionType,
    this.initialSelectedDay,
    this.initialSelectedRange,
    this.onSingleDateSelected,
    this.onRangeSelected,
  });

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  DateTime? selectedDay;
  DateTimeRange? selectedRange;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialSelectedDay;
    selectedRange = widget.initialSelectedRange;
  }

  bool _isRangeValid(DateTime start, DateTime end) {
    for (DateTime d = start;
    d.isBefore(end) || d.isAtSameMomentAs(end);
    d = d.add(const Duration(days: 1))) {
      if (widget.events[d]?.isNotEmpty ?? false) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('🚨 مفاتيح blackoutDates:');
    final normalizedEvents = {
      for (var entry in widget.events.entries)
        DateUtils.dateOnly(entry.key): entry.value,
    };
    final blackoutDates = normalizedEvents.keys.toList();

    // final blackoutDates = widget.events.keys
    //     .map((date) => DateUtils.dateOnly(date))
    //     .toSet()
    //     .toList();

// ثم في monthViewSettings:

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: SfDateRangePicker(
        minDate: DateTime.now(),
        enablePastDates: false,
        backgroundColor: Colors.white,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        showTodayButton: false,
        selectionMode: widget.selectionType == SelectionType.single
            ? DateRangePickerSelectionMode.single
            : DateRangePickerSelectionMode.range,
        todayHighlightColor: CustomTheme.primaryColor,
        onSelectionChanged: (args) {
          if (widget.selectionType == SelectionType.single) {
            final selected = args.value as DateTime;
            if (widget.events[selected]?.isNotEmpty ?? false) {
              // _showDateBookedMessage(context);
            } else {
              setState(() => selectedDay = selected);
              widget.onSingleDateSelected?.call(selected);
            }
          } else if (args.value is PickerDateRange) {
            final range = args.value as PickerDateRange;
            final start = range.startDate;
            final end = range.endDate ?? range.startDate;

            if (_isRangeValid(start!, end!)) {
              setState(() => selectedRange =
                  DateTimeRange(start: start, end: end));
              widget.onRangeSelected?.call(selectedRange!);
            } else {
              // _showDateBookedMessage(context);
            }
          }
        },
        monthViewSettings: DateRangePickerMonthViewSettings(
          blackoutDates: blackoutDates,
          showTrailingAndLeadingDates: false,
          weekendDays: const [DateTime.tuesday, DateTime.friday],
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
          todayTextStyle: const TextStyle(
            color: CustomTheme.color2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
