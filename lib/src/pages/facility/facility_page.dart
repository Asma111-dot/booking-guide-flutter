// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../providers/facility/facility_provider.dart';
// import '../../widgets/view_widget.dart';
// import '../../models/facility.dart';
//
// abstract class FacilityPage extends ConsumerStatefulWidget {
//   final int facilityTypeId;
//   final String pageTitle;
//
//   const FacilityPage({
//     Key? key,
//     required this.facilityTypeId,
//     required this.pageTitle,
//   }) : super(key: key);
//
//   Widget buildFacilityCard(BuildContext context, Facility facility);
//
//   @override
//   ConsumerState createState() => _FacilityPageState();
// }
//
// class _FacilityPageState extends ConsumerState<FacilityPage> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: widget.facilityTypeId);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final facilitiesState = ref.watch(facilitiesProvider);
//
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.pageTitle)),
//       body: ViewWidget<List<Facility>>(
//         meta: facilitiesState.meta,
//         data: facilitiesState.data,
//         onLoaded: (data) {
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final facility = data[index];
//               return widget.buildFacilityCard(context, facility);
//             },
//           );
//         },
//         onLoading: () => const Center(child: CircularProgressIndicator()),
//         onEmpty: () => const Center(child: Text("No data available")),
//         showError: true,
//         showEmpty: true,
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// // import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// //
// // import '../models/room_price.dart';
// // import '../helpers/general_helper.dart';
// // import '../providers/reservation/reservation_save_provider.dart';
// // import '../providers/room_price/room_prices_provider.dart';
// // import '../providers/room_price/room_price_save_provider.dart';
// // import '../utils/routes.dart';
// // import '../utils/theme.dart';
// // import '../widgets/custom_app_bar.dart';
// // import '../widgets/view_widget.dart';
// //
// // class PriceAndCalendarPage extends ConsumerStatefulWidget {
// //   final int roomId;
// //
// //   const PriceAndCalendarPage({Key? key, required this.roomId})
// //       : super(key: key);
// //
// //   @override
// //   ConsumerState<PriceAndCalendarPage> createState() =>
// //       _PriceAndCalendarPageState();
// // }
// //
// // class _PriceAndCalendarPageState extends ConsumerState<PriceAndCalendarPage> {
// //   DateTime? selectedDay;
// //   List<RoomPrice> selectedPrices = [];
// //   RoomPrice? selectedPrice;
// //   Map<DateTime, List<dynamic>> events = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     Future.microtask(() {
// //       _fetchRoomPrices();
// //     });
// //   }
// //
// //   void _fetchRoomPrices() async {
// //     await ref.read(roomPricesProvider.notifier).fetch(roomId: widget.roomId);
// //
// //     final roomPrices = ref.read(roomPricesProvider).data;
// //     if (roomPrices != null && roomPrices.isNotEmpty) {
// //       final defaultPrice = roomPrices.first;
// //       print('Default Price: $defaultPrice');
// //       _populateEvents(selectedPrice: defaultPrice);
// //     } else {
// //       print('No room prices available');
// //       setState(() {
// //         events = {};
// //       });
// //     }
// //   }
// //
// //   void _populateEvents({RoomPrice? selectedPrice}) {
// //     events.clear();
// //     final roomPrices = ref.read(roomPricesProvider).data;
// //
// //     if (roomPrices == null || selectedPrice == null) {
// //       print('No room prices or selected price is null');
// //       setState(() {
// //         events = {};
// //       });
// //       return;
// //     }
// //     if (selectedPrice == null) {
// //       print('Reservations: ${selectedPrice?.reservations}');
// //       print('Selected price is null');
// //       setState(() {
// //         events = {};
// //       });
// //       return;
// //     }
// //     print('Selected Price: $selectedPrice');
// //     print('Reservations: ${selectedPrice.reservations}');
// //     for (var reservation in selectedPrice.reservations) {
// //       try {
// //         final checkInDate = reservation.checkInDate is String
// //             ? DateTime.parse(reservation.checkInDate as String)
// //             : reservation.checkInDate;
// //         final checkOutDate = reservation.checkOutDate is String
// //             ? DateTime.parse(reservation.checkOutDate as String)
// //             : reservation.checkOutDate;
// //
// //         print('Processing reservation: $reservation');
// //         print('Check-in: $checkInDate, Check-out: $checkOutDate');
// //
// //         DateTime currentDate = checkInDate;
// //         while (currentDate.isBefore(checkOutDate) ||
// //             currentDate.isAtSameMomentAs(checkOutDate)) {
// //           events[currentDate] = [...(events[currentDate] ?? []), reservation];
// //           currentDate = currentDate.add(const Duration(days: 1));
// //         }
// //       } catch (e) {
// //         print('Error processing reservation: $e');
// //       }
// //     }
// //     setState(() {});
// //   }
// //
// //   // void _saveRoomPrice() async {
// //   //   if (selectedPrice != null && selectedDay != null) {
// //   //     await ref.read(roomPriceSaveProvider.notifier).saveRoomPrice();
// //   //   } else {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('يرجى اختيار السعر واليوم أولاً')),
// //   //     );
// //   //   }
// //   // }
// //
// //   // void _saveRoomPrice() async {
// //   //   if (selectedPrice != null && selectedDay != null) {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       const SnackBar(content: Text('Saving...')),
// //   //     );
// //   //     try {
// //   //       await ref.read(roomPriceSaveProvider.notifier).saveRoomPrice(selectedPrice! ,selectedDay!);
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(content: Text('تم حفظ السعر بنجاح')),
// //   //       );
// //   //     } catch (e) {
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
// //   //       );
// //   //     }
// //   //   } else {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('يرجى اختيار السعر واليوم أولاً')),
// //   //     );
// //   //   }
// //   // }
// //
// //   // void _saveRoomPrice() async {
// //   //   if (selectedPrice != null && selectedDay != null) {
// //   //     // Show loading state
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       const SnackBar(content: Text('Saving...')),
// //   //     );
// //   //
// //   //     try {
// //   //       // Get the provider's reference
// //   //       final formState = ref.read(formProvider); // or ref.watch(formProvider) depending on your case
// //   //
// //   //       // Call the ReservationSave provider's saveReservation method
// //   //       await ref.read(reservationSaveProvider.notifier).saveReservationDraft(formState);
// //   //
// //   //       // Show success message
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(content: Text('تم حفظ السعر بنجاح')),
// //   //       );
// //   //     } catch (e) {
// //   //       // Show error message if an error occurs
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
// //   //       );
// //   //     }
// //   //   } else {
// //   //     // Show validation message if no price or day is selected
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text('يرجى اختيار السعر واليوم أولاً')),
// //   //     );
// //   //   }
// //   // }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final roomPriceState = ref.watch(roomPricesProvider);
// //    // final roomPriceSaveState = ref.watch(roomPriceSaveProvider);
// //     final reservationSaveState = ref.watch(formProvider);
// //
// //
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: CustomAppBar(
// //         appTitle: trans().availabilityCalendar,
// //         icon: const FaIcon(Icons.arrow_back_ios),
// //       ),
// //       body: ViewWidget<List<RoomPrice>>(
// //         meta: roomPriceState.meta,
// //         data: roomPriceState.data,
// //         refresh: () async => await ref
// //             .read(roomPricesProvider.notifier)
// //             .fetch(roomId: widget.roomId),
// //         forceShowLoaded: roomPriceState.data != null,
// //         onLoaded: (data) {
// //           return ListView.builder(
// //               scrollDirection: Axis.horizontal,
// //               itemCount: data.length,
// //               itemBuilder: (context, index) {
// //                 final price = roomPriceState.data![index];
// //                 return Column(
// //                   children: [
// //                     _buildPriceCard(price),
// //                     SizedBox(
// //                       height: MediaQuery.of(context).size.height * 0.6,
// //                       child: SfDateRangePicker(
// //                         view: DateRangePickerView.month,
// //                         showNavigationArrow: true,
// //                         showTodayButton: false,
// //                         selectionMode: DateRangePickerSelectionMode.single,
// //                         onSelectionChanged: (args) {
// //                           final selectedDate = args.value;
// //                           if (events[selectedDate]?.isEmpty ?? true) {
// //                             setState(() {
// //                               print('no data');
// //                               this.selectedDay = selectedDate;
// //                             });
// //                           } else {
// //                             print('has data');
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               SnackBar(content: Text(trans().dateNotAvailable)),
// //                             );
// //                           }
// //                         },
// //                         monthViewSettings: DateRangePickerMonthViewSettings(
// //                           dayFormat: 'd',
// //                           specialDates: events.keys.toList(),
// //                           showTrailingAndLeadingDates: false,
// //                           weekendDays: <int>[
// //                             DateTime.friday,
// //                             DateTime.saturday
// //                           ],
// //                         ),
// //                         monthCellStyle: DateRangePickerMonthCellStyle(
// //                           specialDatesDecoration: BoxDecoration(
// //                             color: Colors.red.withOpacity(0.5),
// //                             shape: BoxShape.circle,
// //                           ),
// //                           specialDatesTextStyle: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                           todayTextStyle: TextStyle(
// //                             color: Colors.blue,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                           todayCellDecoration: BoxDecoration(
// //                             color: Colors.blue.withOpacity(0.5),
// //                             shape: BoxShape.circle,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     FloatingActionButton.extended(
// //                       backgroundColor:
// //                           selectedDay != null && selectedPrice != null
// //                               ? CustomTheme.primaryColor
// //                               : Colors.grey.shade400,
// //                       onPressed: selectedDay != null && selectedPrice != null
// //                           ? () async {
// //                         // await ref.read(roomPriceSaveProvider.notifier).saveRoomPrice(selectedPrice! ,selectedDay!);
// //                         await ref.read(reservationSaveProvider.notifier).saveReservationDraft(reservationSaveState);
// //                         print("تم الحفظ ..");
// //                         Navigator.pushNamed(
// //                           context,
// //                           Routes.reservation,
// //                           arguments: price,
// //
// //                         );
// //                         // if (selectedDay != null && selectedPrice != null) {
// //                               // await _saveRoomPrice();
// //                               // if (reservationSaveState) {
// //                               //   ScaffoldMessenger.of(context).showSnackBar(
// //                               //     SnackBar(content: Text('تم حفظ  بنجاح')),
// //                               //   );
// //                               //   Navigator.pushNamed(
// //                               //     context,
// //                               //     Routes.reservation,
// //                               //     arguments: price,
// //                               //   );
// //                               // } else if (roomPriceSaveState.isError()) {
// //                               //   ScaffoldMessenger.of(context).showSnackBar(
// //                               //     SnackBar(
// //                               //         content: Text(
// //                               //             'حدث خطأ: ${roomPriceSaveState.isError()}')),
// //
// //
// //                             }
// //                           : () {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 SnackBar(
// //                                     content:
// //                                         Text('يرجى اختيار السعر واليوم أولاً')),
// //                               );
// //                             },
// //                       label: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Text(
// //                             trans().continueBooking,
// //                             style: const TextStyle(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 8),
// //                           const Icon(Icons.arrow_forward),
// //                         ],
// //                       ),
// //                     )
// //                   ],
// //                 );
// //               });
// //         },
// //         onLoading: () => const Center(child: CircularProgressIndicator()),
// //         onEmpty: () => const Center(
// //           child: Text(
// //             "لا توجد بيانات",
// //             style: TextStyle(color: CustomTheme.placeholderColor),
// //           ),
// //         ),
// //         showError: true,
// //         showEmpty: true,
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPriceCard(RoomPrice roomPrice) {
// //     return GestureDetector(
// //       onTap: () {
// //         setState(() {
// //           selectedPrice = roomPrice;
// //           _populateEvents();
// //         });
// //       },
// //       child: Container(
// //         width: MediaQuery.of(context).size.width * 0.5,
// //         margin: const EdgeInsets.symmetric(horizontal: 8),
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: selectedPrice == roomPrice
// //               ? CustomTheme.primaryColor
// //               : Colors.white,
// //           borderRadius: BorderRadius.circular(8),
// //           border: Border.all(color: CustomTheme.primaryColor),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.2),
// //               blurRadius: 4,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               children: [
// //                 Icon(Icons.calendar_today,
// //                     size: 16, color: _getColor(roomPrice)),
// //                 const SizedBox(width: 4),
// //                 Flexible(
// //                   child: Text(
// //                     roomPrice.period,
// //                     style: _getTextStyle(roomPrice),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             Row(
// //               children: [
// //                 Icon(Icons.access_time, size: 16, color: _getColor(roomPrice)),
// //                 const SizedBox(width: 4),
// //                 Flexible(
// //                   child: Text(
// //                     '${roomPrice.timeFrom ?? '--:--'} - ${roomPrice.timeTo ?? '--:--'}',
// //                     style: _getTextStyle(roomPrice),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             Row(
// //               children: [
// //                 Icon(Icons.monetization_on_outlined,
// //                     size: 16, color: _getColor(roomPrice)),
// //                 const SizedBox(width: 8),
// //                 Flexible(
// //                   child: Text(
// //                     "${roomPrice.amount} ${trans().riyalY}",
// //                     style: _getTextStyle(roomPrice),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             Row(
// //               children: [
// //                 Icon(Icons.money_off_sharp,
// //                     size: 16, color: _getColor(roomPrice)),
// //                 const SizedBox(width: 8),
// //                 Flexible(
// //                   child: Text(
// //                     "${trans().deposit} ${roomPrice.deposit} ${trans().riyalY}",
// //                     style: _getTextStyle(roomPrice),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Color _getColor(RoomPrice roomPrice) {
// //     return selectedPrice == roomPrice ? Colors.white : CustomTheme.primaryColor;
// //   }
// //
// //   TextStyle _getTextStyle(RoomPrice roomPrice) {
// //     return TextStyle(
// //       color:
// //           selectedPrice == roomPrice ? Colors.white : CustomTheme.primaryColor,
// //       fontWeight: FontWeight.bold,
// //     );
// //   }
// // }
//
// itemBuilder: (context, index) {
// final price = roomPriceState.data![index];
// return Column(
// children: [
// _buildPriceCard(price),
// SizedBox(
// height: MediaQuery.of(context).size.height * 0.4,
// child: SfDateRangePicker(
// backgroundColor: Colors.white,
// view: DateRangePickerView.month,
// // monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 6),
// showNavigationArrow: true,
// showTodayButton: false,
// selectionMode: DateRangePickerSelectionMode.single,
// onSelectionChanged: (args) {
// final selectedDate = args.value;
// if (events[selectedDate]?.isEmpty ?? true) {
// setState(() {
// this.selectedDay = selectedDate;
// });
// } else {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text(trans().dateNotAvailable)),
// );
// }
// },
// monthViewSettings: DateRangePickerMonthViewSettings(
// dayFormat: 'E',
// specialDates: events.keys.toList(),
// showTrailingAndLeadingDates: false,
// weekendDays: <int>[
// DateTime.tuesday,
// DateTime.friday
// ],
// ),
// monthCellStyle: DateRangePickerMonthCellStyle(
// specialDatesDecoration: BoxDecoration(
// color: Colors.red.withOpacity(0.5),
// shape: BoxShape.circle,
// ),
// specialDatesTextStyle: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// ),
// todayTextStyle: TextStyle(
// color: Colors.blue,
// fontWeight: FontWeight.bold,
// ),
// todayCellDecoration: BoxDecoration(
// color: Colors.blue.withOpacity(0.5),
// shape: BoxShape.circle,
// ),
// ),
// ),
// ),
// FloatingActionButton.extended(
// backgroundColor:
// selectedDay != null && selectedPrice != null
// ? CustomTheme.primaryColor
//     : Colors.grey.shade400,
// onPressed: selectedDay != null && selectedPrice != null
// ? () async {
// // await ref.read(roomPriceSaveProvider.notifier).saveRoomPrice(selectedPrice! ,selectedDay!);
// await ref
//     .read(reservationSaveProvider.notifier)
//     .saveReservationDraft(reservationSaveState);
// print("تم الحفظ ..");
// Navigator.pushNamed(
// context,
// Routes.reservation,
// arguments: price,
// );
// }
//     : () {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content:
// Text('يرجى اختيار السعر واليوم أولاً')),
// );
// },
// label: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// Text(
// trans().continueBooking,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// ),
// const SizedBox(width: 8),
// const Icon(Icons.arrow_forward),
// ],
// ),
// )
// ],
// );
// });
