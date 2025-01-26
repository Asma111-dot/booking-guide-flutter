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

// import 'package:booking_guide/src/widgets/view_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../helpers/general_helper.dart';
// import '../models/reservation.dart' as res;
// import '../models/room_price.dart';
// import '../providers/auth/user_provider.dart';
// import '../providers/reservation/reservation_save_provider.dart';
// import '../providers/room_price/room_prices_provider.dart';
// import '../utils/routes.dart';
// import '../widgets/custom_app_bar.dart';
//
// class ReservationPage extends ConsumerStatefulWidget {
//   final RoomPrice roomPrice;
//
//   const ReservationPage({
//     Key? key,
//     required this.roomPrice,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<ReservationPage> createState() => _ReservationPageState();
// }
//
// class _ReservationPageState extends ConsumerState<ReservationPage> {
//   late TextEditingController adultsController;
//   late TextEditingController childrenController;
//   String bookingType = 'Family (Women and Men)';
//
//   @override
//   void initState() {
//     super.initState();
//     adultsController = TextEditingController();
//     childrenController = TextEditingController();
//
//     // Future.microtask(() async {
//     //   final roomId = widget.roomPrice.reservations.first.id;
//     //   final reservation = widget.roomPrice.reservations.first;
//     //
//     //   await ref.read(roomPricesProvider.notifier).fetch(roomId: roomId);
//     //   ref.read(reservationProvider.notifier).fetch(reservationId: roomId);
//     //   ref.read(formProvider.notifier).updateField(
//     //     roomPriceId: widget.roomPrice.id,
//     //     checkInDate: reservation.checkInDate,
//     //     checkOutDate: reservation.checkOutDate,
//     //     id: reservation.id,
//     //     bookingType: reservation.bookingType,
//     //     adultsCount: reservation.adultsCount,
//     //     childrenCount: reservation.childrenCount,
//     //   );
//     // });
//     Future.microtask(() {
//       final reservation = widget.roomPrice.reservations.first;
//       ref.read(formProvider.notifier).updateField(
//         id: reservation.id,
//         roomPriceId: widget.roomPrice.id,
//         checkInDate: reservation.checkInDate,
//         checkOutDate: reservation.checkOutDate,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     adultsController.dispose();
//     childrenController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final formState = ref.watch(formProvider);
//     final roomPriceState = ref.watch(roomPricesProvider);
//     final currentUserId = ref.watch(userProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         appTitle: "استكمال الحجز",
//         icon: const FaIcon(Icons.arrow_back_ios),
//       ),
//       body: ViewWidget<List<RoomPrice>>(
//         meta: roomPriceState.meta,
//         data: roomPriceState.data,
//         refresh: () => ref.read(roomPricesProvider.notifier).fetch(
//           roomId: widget.roomPrice.reservations.first.id,
//         ),
//         forceShowLoaded: roomPriceState.data != null,
//         onLoaded: (data) => Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("نوع الحضور:"),
//               DropdownButtonFormField<String>(
//                 value: bookingType,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'Family (Women and Men)',
//                     child: Text('Family (Women and Men)'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Women Only',
//                     child: Text('Women Only'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'Men Only',
//                     child: Text('Men Only'),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   // setState(() {
//                   //   bookingType = value!;
//                   // });
//                   ref
//                       .read(formProvider.notifier)
//                       .updateField(bookingType: value, id: 0);
//                   print("نوع الحجز المختار: $value");
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               TextField(
//                   controller: adultsController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: "عدد الكبار",
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (value) {
//                     ref
//                         .read(formProvider.notifier)
//                         .updateField(adultsCount: int.tryParse(value), id: 0);
//                     print("عدد الكبار: ${int.tryParse(value)}");
//                   }),
//               const SizedBox(height: 30),
//               TextField(
//                   controller: childrenController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: "عدد الأطفال",
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (value) {
//                     ref
//                         .read(formProvider.notifier)
//                         .updateField(childrenCount: int.tryParse(value), id: 0);
//                     print("عدد الأطفال: ${int.tryParse(value)}");
//                   }),
//               const Spacer(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("السابق"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//
//                       ref.read(formProvider.notifier).updateField(
//                         bookingType: bookingType,
//                         adultsCount: int.tryParse(adultsController.text) ?? 0,
//                         childrenCount: int.tryParse(childrenController.text) ?? 0,
//                         id: 0,
//                         checkInDate: formState.checkInDate,
//                         checkOutDate: formState.checkOutDate,
//                       );
//                       print("بيانات الحجز التي سيتم إرسالها:");
//                       print("User ID: ${formState.userId}");
//                       print("Booking Type: ${formState.bookingType}");
//                       print("عدد الكبار: ${formState.adultsCount}");
//                       print("عدد الأطفال: ${formState.childrenCount}");
//                       print("تاريخ الوصول: ${formState.checkInDate}");
//                       print("تاريخ المغادرة: ${formState.checkOutDate}");
//
//                       await ref
//                           .read(reservationSaveProvider.notifier)
//                           .saveReservation(formState);
//
//                       Navigator.pushNamed(context, Routes.reservationDetails);
//                     },
//                     child: const Text("التالي"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//button reservation
// Align(
//   alignment: Alignment.bottomLeft,
//   child: Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: FloatingActionButton.extended(
//       backgroundColor: selectedDay != null && selectedPrice != null
//           ? CustomTheme.primaryColor
//           : Colors.grey.shade400,
//       onPressed: selectedDay != null && selectedPrice != null
//           ? () async {
//               ref
//                   .read(reservationSaveProvider.notifier)
//                   .saveReservationDraft(
//                     Reservation(
//                       roomPriceId: selectedPrice!.id,
//                       checkInDate: selectedDay!,
//                       checkOutDate: selectedDay!,
//                       id: 0,
//                       bookingType: '',
//                     ),
//                   );
//               print('Saving reservation draft...');
//               print('Room Price ID: ${selectedPrice!.id}');
//               print('Check-In Date: ${selectedDay}');
//               print('Check-Out Date: ${selectedDay}');
//
//               await ref
//                   .read(reservationSaveProvider.notifier)
//                   .saveReservationDraft(reservation.data!);
//
//               Navigator.pushNamed(
//                 context,
//                 Routes.reservation,
//                 arguments: selectedPrice,
//               );
//             }
//           : () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('يرجى اختيار السعر واليوم أولاً'),
//                 ),
//               );
//             },
//       label: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             trans().continueBooking,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 8),
//           const Icon(Icons.arrow_forward),
//         ],
//       ),
//     ),
//   ),
// ),

// SizedBox(
// height: MediaQuery.of(context).size.height * 0.4,
// child: SfDateRangePicker(
// backgroundColor: Colors.white,
// view: DateRangePickerView.month,
// showNavigationArrow: true,
// showTodayButton: false,
// selectionMode: DateRangePickerSelectionMode.single,
// onSelectionChanged: (args) {
// final selectedDate = args.value;
// if (events[selectedDate]?.isEmpty ?? false) {
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text(trans().dateNotAvailable)),
// );
// } else {
// setState(() {
// this.selectedDay = selectedDate;
// });
// }
// },
// monthViewSettings: DateRangePickerMonthViewSettings(
// dayFormat: 'E',
// specialDates: events.keys.toList(),
// showTrailingAndLeadingDates: false,
// weekendDays: <int>[DateTime.tuesday, DateTime.friday],
// ),
// monthCellStyle: DateRangePickerMonthCellStyle(
// // specialDatesDecoration: BoxDecoration(
// //   color: Colors.red.withOpacity(0.5),
// //   shape: BoxShape.circle,
// // ),
// specialDatesTextStyle: TextStyle(
// color: Colors.grey,
// fontWeight: FontWeight.bold,
// decoration: TextDecoration.lineThrough,
// ),
// todayTextStyle: TextStyle(
// color: Colors.black,
// fontWeight: FontWeight.bold,
// ),
// todayCellDecoration: BoxDecoration(
// color: Colors.blue.withOpacity(0.5),
// shape: BoxShape.circle,
// ),
// ),
// ),
// ),
// body: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// 'وسائل الدفع',
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// ),
// const SizedBox(height: 16),
// GestureDetector(
// onTap: () {
// setState(() {
// selectedPaymentMethod = 'فلوسك';
// });
// },
// child: Container(
// decoration: BoxDecoration(
// color: selectedPaymentMethod == 'فلوسك'
// ? Colors.grey[300]
//     : Colors.grey[200],
// borderRadius: BorderRadius.circular(8),
// border: Border.all(
// color: selectedPaymentMethod == 'فلوسك'
// ? CustomTheme.primaryColor
//     : Colors.grey,
// width: 1,
// ),
// ),
// padding: const EdgeInsets.symmetric(
// horizontal: 16,
// vertical: 12,
// ),
// child: Row(
// children: [
// Image.asset(
// floosakImage,
// width: 40,
// height: 40,
// errorBuilder: (context, error, stackTrace) {
// return Icon(Icons.error,
// color: Colors.red,
// size: 40);
// },
// ),
// const SizedBox(width: 16),
// Flexible(
// child: Text(
// 'فلوسك',
// style: TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// color: Colors.black,
// ),
// overflow: TextOverflow.ellipsis,
// ),
// ),
// ],
// ),
// ),
// ),
// const Spacer(),
// Button(
// width: MediaQuery.of(context).size.width - 40,
// title: 'إتمام الحجز',
// disable: false,
// icon: Icon(
// Icons.arrow_forward,
// size: 20,
// color: Colors.white,
// ),
// iconAfterText: true,
// onPressed: () async {
// if (selectedPaymentMethod == 'فلوسك') {
// print('تم اختيار وسيلة الدفع: فلوسك');
// }
// },
// ),
// ],
// ),
// ),
