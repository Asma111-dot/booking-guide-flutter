// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../helpers/general_helper.dart';
// import '../pages/facility_page.dart';
// import '../providers/auth/user_provider.dart';
// import '../providers/facility_type/facility_type_provider.dart';
// import '../utils/assets.dart';
// import '../utils/routes.dart';
// import '../utils/theme.dart';
//
// class FacilityTypesPage extends ConsumerStatefulWidget {
//   const FacilityTypesPage({super.key});
//
//   @override
//   ConsumerState createState() => _FacilityTypesPageState();
// }
//
// class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
//   int? selectedFacilityType;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(facilityTypesProvider.notifier).fetch();
//       ref.read(userProvider.notifier).fetch();
//     });
//   }
//
//   void _onFacilityTypeChange(int facilityTypeId) {
//     setState(() {
//       selectedFacilityType = facilityTypeId;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final facilityTypesState = ref.watch(facilityTypesProvider);
//     final user = ref.watch(userProvider).data;
//
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;
//
//     if (facilityTypesState.data != null &&
//         facilityTypesState.data!.isNotEmpty &&
//         selectedFacilityType == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         setState(() {
//           selectedFacilityType = facilityTypesState.data!.first.id;
//         });
//       });
//     }
//
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 15),
//           Center(
//             child: Image.asset(
//               booking,
//               width: 150,
//               height: 50,
//               fit: BoxFit.contain,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   textDirection: TextDirection.rtl,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 22,
//                       backgroundColor: colorScheme.surfaceVariant,
//                       backgroundImage: (user?.media.isNotEmpty ?? false)
//                           ? NetworkImage(user!.media.first.original_url)
//                           : AssetImage(defaultAvatar) as ImageProvider,
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: Text.rich(
//                         TextSpan(
//                           text: trans().hello_user,
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: colorScheme.secondary,
//                           ),
//                           children: [
//                             TextSpan(
//                               text: user?.name ?? "User",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                                 color: colorScheme.primary,
//                               ),
//                             ),
//                           ],
//                         ),
//                         textDirection: TextDirection.rtl,
//                       ),
//                     ),
//                     IconButton(
//                       icon: (whatsappIcon),
//                       color: Colors.green,
//                       onPressed: () => launchUrl(Uri.parse("https://wa.me/775421110")),
//                     ),
//                     IconButton(
//                       icon: const Icon(notificationIcon),
//                       color: colorScheme.onSurface.withOpacity(0.6),
//                       onPressed: () {},
//                     ),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       if (selectedFacilityType == null) return;
//                       Navigator.pushNamed(context, Routes.filter, arguments: selectedFacilityType!);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: colorScheme.surface,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(searchIcon, color: colorScheme.secondary),
//                           const SizedBox(width: 10),
//                           Text(
//                             trans().search_in_facilities,
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w400,
//                               color: colorScheme.onSurface.withOpacity(0.6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     if (selectedFacilityType == null) return;
//                     Navigator.pushNamed(context, Routes.filter, arguments: selectedFacilityType!);
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       gradient: CustomTheme.primaryGradient,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: const Icon(trueIcon, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: facilityTypesState.data == null || facilityTypesState.data!.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: facilityTypesState.data!.map((facilityType) {
//                   IconData icon;
//
//                   if (facilityType.id == 1) {
//                     icon = hotelIcon;
//                   } else if (facilityType.id == 2) {
//                     icon = poolIcon;
//                   } else if (facilityType.id == 3) {
//                     icon = doveIcon;
//                   } else {
//                     icon = defaultFacilityIcon;
//                   }
//
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 5),
//                     child: _buildTypeButtonWithIcon(
//                       context,
//                       facilityType.name,
//                       facilityType.id,
//                       icon,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: selectedFacilityType == null
//                 ? Center(child: CircularProgressIndicator())//edit ///
//                 : FacilityPage(facilityTypeId: selectedFacilityType!),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildTypeButtonWithIcon(
//       BuildContext context,
//       String title,
//       int typeId,
//       IconData icon,
//       ) {
//     final isSelected = selectedFacilityType == typeId;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return GestureDetector(
//       onTap: () => _onFacilityTypeChange(typeId),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//         decoration: BoxDecoration(
//           color: isSelected ? colorScheme.secondary.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withOpacity(0.6),
//               size: 24,
//             ),
//             const SizedBox(width: 10),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w700,
//                 color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
