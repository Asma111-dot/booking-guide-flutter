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
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialSelectedDay;
    selectedRange = widget.initialSelectedRange;
    if (widget.selectionType == SelectionType.single && selectedDay != null) {
      _controller.selectedDate = selectedDay;
    } else if (widget.selectionType == SelectionType.range &&
        selectedRange != null) {
      _controller.selectedRange = PickerDateRange(
        selectedRange!.start,
        selectedRange!.end,
      );
    }
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
    // final normalizedEvents = {
    //   for (var entry in widget.events.entries)
    //     DateUtils.dateOnly(entry.key): entry.value,
    // };
    // final blackoutDates = normalizedEvents.keys.toList();
    final blackoutDates = widget.events.keys
        .map((d) => DateUtils.dateOnly(d))
        .toList();

    debugPrint('🚫 blackoutDates => $blackoutDates');

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: SfDateRangePicker(
        controller: _controller,
        initialDisplayDate: widget.selectionType == SelectionType.single
            ? (selectedDay ?? widget.initialSelectedDay ?? DateTime.now())
            : (selectedRange?.start ?? widget.initialSelectedRange?.start ?? DateTime.now()),
        selectionMode: widget.selectionType == SelectionType.single
            ? DateRangePickerSelectionMode.single
            : DateRangePickerSelectionMode.range,
        minDate: DateTime.now(),
        enablePastDates: false,
        backgroundColor: colorScheme.background,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        showTodayButton: false,
        todayHighlightColor: CustomTheme.color3,
        selectionColor: CustomTheme.color3,
        rangeSelectionColor: CustomTheme.color2.withOpacity(0.3),
        startRangeSelectionColor: CustomTheme.color3,
        endRangeSelectionColor: CustomTheme.color3,
        selectionTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        rangeTextStyle: TextStyle(
          color: CustomTheme.color3,
          fontWeight: FontWeight.bold,
        ),

        onSelectionChanged: (args) {
          if (args.value is DateTime && widget.selectionType == SelectionType.single) {
            final selected = DateUtils.dateOnly(args.value as DateTime);
            if (widget.events[selected]?.isNotEmpty ?? false) {
            } else {
              setState(() => selectedDay = selected);
              widget.onSingleDateSelected?.call(selected);
            }
          } else if (args.value is PickerDateRange &&
              widget.selectionType == SelectionType.range) {
            final range = args.value as PickerDateRange;

            final rawStart = range.startDate;
            final rawEnd = range.endDate ?? range.startDate;

            if (rawStart == null || rawEnd == null) return;

            final start = DateUtils.dateOnly(rawStart);
            final end = DateUtils.dateOnly(rawEnd);

            if (_isRangeValid(start, end)) {
              setState(() => selectedRange = DateTimeRange(start: start, end: end));
              widget.onRangeSelected?.call(selectedRange!);
            } else {
              // أظهر رسالة بأن المدى يحتوي تواريخ محجوزة
            }
          } else {
            debugPrint("🚨 قيمة غير متوقعة من onSelectionChanged: ${args.value}");
          }
        },

        monthViewSettings: DateRangePickerMonthViewSettings(
          dayFormat: 'EEE', // استخدم 'EE' أو حتى 'E' لتقليل عرض النص
          // dayFormat: Localizations.localeOf(context).languageCode == 'ar' ? 'EE' : 'E',
          blackoutDates: blackoutDates,
          showTrailingAndLeadingDates: false,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,

            decoration: TextDecoration.combine([
              TextDecoration.lineThrough,
              TextDecoration.lineThrough,
            ]),
            decorationColor: CustomTheme.color4,
            decorationThickness: 3,
          ),

          todayTextStyle: TextStyle(
            color: CustomTheme.color2,
            fontWeight: FontWeight.bold,
          ),
          textStyle: TextStyle(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
