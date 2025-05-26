// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../providers/favorite/favorite_provider.dart';
// // import '../storage/auth_storage.dart';
// //
// // class SaveButtonWidget extends ConsumerWidget {
// //   final int itemId;
// //   final Color iconColor;
// //   final int facilityTypeId;
// //
// //   const SaveButtonWidget({
// //     Key? key,
// //     required this.itemId,
// //     this.iconColor = Colors.blue,
// //     required this.facilityTypeId,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final favoriteNotifier = ref.read(favoritesProvider.notifier);
// //     final bool isSaved = favoriteNotifier.isFavorite(itemId);
// //
// //     return IconButton(
// //       icon: Icon(
// //         isSaved ? Icons.favorite : Icons.favorite_border,
// //         color: isSaved ? Colors.red : iconColor,
// //       ),
// //       onPressed: () async {
// //         final userId = currentUser()?.id;
// //         if (userId == null) return;
// //
// //         if (isSaved) {
// //           await favoriteNotifier.removeFavorite(ref, userId, itemId);
// //         } else {
// //           await favoriteNotifier.addFavorite(ref, userId, itemId);
// //         }
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// import '../utils/theme.dart';
//
// enum SelectionType { single, range }
//
// class CustomCalendarWidget extends StatefulWidget {
//   final Map<DateTime, List<String>> events;
//   final SelectionType selectionType;
//   final DateTime? initialSelectedDay;
//   final DateTimeRange? initialSelectedRange;
//   final Function(DateTime selectedDate)? onSingleDateSelected;
//   final Function(DateTimeRange selectedRange)? onRangeSelected;
//
//   const CustomCalendarWidget({
//     super.key,
//     required this.events,
//     required this.selectionType,
//     this.initialSelectedDay,
//     this.initialSelectedRange,
//     this.onSingleDateSelected,
//     this.onRangeSelected,
//   });
//
//   @override
//   _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
// }
//
// class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
//   DateTime? selectedDay;
//   DateTimeRange? selectedRange;
//   final DateRangePickerController _controller = DateRangePickerController();
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDay = widget.initialSelectedDay;
//     selectedRange = widget.initialSelectedRange;
//     if (widget.selectionType == SelectionType.single && selectedDay != null) {
//       _controller.selectedDate = selectedDay;
//     } else if (widget.selectionType == SelectionType.range && selectedRange != null) {
//       _controller.selectedRange = PickerDateRange(
//         selectedRange!.start,
//         selectedRange!.end,
//       );
//     }
//
//   }
//
//   bool _isRangeValid(DateTime start, DateTime end) {
//     for (DateTime d = start;
//     d.isBefore(end) || d.isAtSameMomentAs(end);
//     d = d.add(const Duration(days: 1))) {
//       if (widget.events[d]?.isNotEmpty ?? false) return false;
//     }
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('🚨 مفاتيح blackoutDates:');
//     final normalizedEvents = {
//       for (var entry in widget.events.entries)
//         DateUtils.dateOnly(entry.key): entry.value,
//     };
//     final blackoutDates = normalizedEvents.keys.toList();
//
//     final colorScheme = Theme.of(context).colorScheme;
//
//     // لا نحذف أي سطر، فقط نضيف التعديلات على الألوان
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.45,
//       child: SfDateRangePicker(
//         controller: _controller,
//         minDate: DateTime.now(),
//         enablePastDates: false,
//         backgroundColor: colorScheme.background, // ✅ دعم الوضع الليلي
//         view: DateRangePickerView.month,
//         showNavigationArrow: true,
//         showTodayButton: false,
//         selectionMode: widget.selectionType == SelectionType.single
//             ? DateRangePickerSelectionMode.single
//             : DateRangePickerSelectionMode.range,
//         todayHighlightColor: CustomTheme.color2,
//         // selectionColor: CustomTheme.color4,
//         selectionColor: Colors.greenAccent,
//         rangeSelectionColor: CustomTheme.primaryColor.withOpacity(0.3),
//         startRangeSelectionColor: CustomTheme.primaryColor,
//         endRangeSelectionColor: CustomTheme.primaryColor,
//         selectionTextStyle: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//         rangeTextStyle: TextStyle(
//           color: Colors.white,
//         ),
//
//         onSelectionChanged: (args) {
//           if (widget.selectionType == SelectionType.single) {
//             final selected = args.value as DateTime;
//             if (widget.events[selected]?.isNotEmpty ?? false) {
//               // _showDateBookedMessage(context);
//             } else {
//               setState(() => selectedDay = selected);
//               widget.onSingleDateSelected?.call(selected);
//             }
//           } else if (args.value is PickerDateRange) {
//             final range = args.value as PickerDateRange;
//             final start = range.startDate;
//             final end = range.endDate ?? range.startDate;
//
//             // if (start != null && end != null) {
//             // setState(() => selectedRange = DateTimeRange(start: start, end: end));
//             // widget.onRangeSelected?.call(selectedRange!);
//             // }
//           }
//         },
//         monthViewSettings: DateRangePickerMonthViewSettings(
//           blackoutDates: blackoutDates,
//           showTrailingAndLeadingDates: false,
//           weekendDays: const [DateTime.tuesday, DateTime.friday],
//         ),
//         monthCellStyle: DateRangePickerMonthCellStyle(
//           blackoutDateTextStyle: TextStyle(
//             color: Colors.grey,
//             decoration: TextDecoration.lineThrough,
//           ),
//           todayTextStyle: TextStyle(
//             color: CustomTheme.color2,
//             fontWeight: FontWeight.bold,
//           ),
//           // textStyle: TextStyle(
//           //   color: colorScheme.onSurface, // ✅ دعم الوضع الليلي
//           // ),
//         ),
//       ),
//     );
//   }
// }
