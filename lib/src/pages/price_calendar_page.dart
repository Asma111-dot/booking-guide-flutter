import 'package:booking_guide/src/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/room_price.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';

class PriceAndCalendarPage extends ConsumerStatefulWidget {
  final int roomId;

  const PriceAndCalendarPage({Key? key, required this.roomId})
      : super(key: key);

  @override
  ConsumerState<PriceAndCalendarPage> createState() =>
      _PriceAndCalendarPageState();
}

class _PriceAndCalendarPageState extends ConsumerState<PriceAndCalendarPage> {
  DateTime? selectedDay;

  // List<RoomPrice> selectedPrices = [];
  RoomPrice? selectedPrice;
  Map<DateTime, List<dynamic>> events = {};

  late TextEditingController adultsController;
  late TextEditingController childrenController;
  String bookingType = 'Family (Women and Men)';
  final GlobalKey<FormState> reservationKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    adultsController = TextEditingController();
    childrenController = TextEditingController();
    Future.microtask(() {
      _fetchRoomPrices();
    });
  }

  @override
  void dispose() {
    adultsController.dispose();
    childrenController.dispose();
    super.dispose();
  }

  void _fetchRoomPrices() async {
    await ref.read(roomPricesProvider.notifier).fetch(roomId: widget.roomId);

    final roomPrices = ref.read(roomPricesProvider).data;
    if (roomPrices != null && roomPrices.isNotEmpty) {
      final defaultPrice = roomPrices.first;
      print('Default Price: $defaultPrice');
      _populateEvents();
    } else {
      print('No room prices available');
      setState(() {
        events = {};
      });
    }
  }

  void _populateEvents({RoomPrice? selectedPrice}) {
    events.clear();
    final roomPrices = ref.read(roomPricesProvider).data;

    if (roomPrices == null || selectedPrice == null) {
      setState(() {
        events = {};
      });
      return;
    }

    for (var reservation in selectedPrice.reservations) {
      try {
        final checkInDate = reservation.checkInDate is String
            ? DateTime.parse(reservation.checkInDate as String)
            : reservation.checkInDate;
        final checkOutDate = reservation.checkOutDate is String
            ? DateTime.parse(reservation.checkOutDate as String)
            : reservation.checkOutDate;

        print('Processing reservation: $reservation');
        print('Check-in: $checkInDate, Check-out: $checkOutDate');

        DateTime currentDate = checkInDate;
        while (currentDate.isBefore(checkOutDate) ||
            currentDate.isAtSameMomentAs(checkOutDate)) {
          events[currentDate] = [...(events[currentDate] ?? []), reservation];
          currentDate = currentDate.add(const Duration(days: 1));
        }
      } catch (e) {
        print('Error processing reservation: $e');
      }
    }
    //ref.read(reservationSaveProvider.notifier).saveReservationDraft(selectedDay as Reservation);
    setState(() {});
  }

  void _saveReservation() {
    final reservationNotifier = ref.read(reservationSaveProvider.notifier);
    // reservationNotifier.saveReservation({
    //   'booking_type': bookingType,
    //   'adults': int.tryParse(adultsController.text) ?? 0,
    //   'children': int.tryParse(childrenController.text) ?? 0,
    // });
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);
    final reservation = ref.watch(reservationSaveProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().availabilityCalendar,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Stack(
        children: [
          ViewWidget<List<RoomPrice>>(
            meta: roomPriceState.meta,
            data: roomPriceState.data,
            refresh: () async => await ref
                .read(roomPricesProvider.notifier)
                .fetch(roomId: widget.roomId),
            forceShowLoaded: roomPriceState.data != null,
            onLoaded: (data) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final roomPrice = roomPriceState.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: _buildPriceCard(roomPrice),
                          );
                        },
                      ),
                    ),

                    // calender
                    const SizedBox(height: 16),
                    _buildCalendar(),
                    const SizedBox(height: 16),
                    _buildInputFields(),
                  ],
                ),
              );
            },
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onEmpty: () => const Center(
              child: Text(
                "لا توجد بيانات",
                style: TextStyle(color: CustomTheme.placeholderColor),
              ),
            ),
            showError: true,
            showEmpty: true,
          ),

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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                backgroundColor: selectedDay != null &&
                        selectedPrice != null &&
                        adultsController != null &&
                        childrenController != null &&
                        bookingType != null
                    ? CustomTheme.primaryColor
                    : Colors.grey.shade400,
                onPressed: selectedDay != null &&
                        selectedPrice != null &&
                        adultsController != null &&
                        childrenController != null &&
                        bookingType != null
                    ? () async {
                        print("بيانات الحجز قبل الحفظ:");
                        print("Room Price ID: ${selectedPrice!.id}");
                        print("Check-In Date: $selectedDay");
                        print("Check-Out Date: $selectedDay");
                        print("Reservation Details: ${reservation.data}");

                        final newReservation = Reservation(
                          roomPriceId: selectedPrice!.id,
                          checkInDate: selectedDay!,
                          checkOutDate: selectedDay!,
                          bookingType: 'direct',
                          id: reservation.data?.id ?? 0,
                          adultsCount: reservation.data?.adultsCount ?? 0,
                          childrenCount: reservation.data?.childrenCount ?? 0,
                          totalPrice: reservation.data?.totalPrice ?? 0,
                        );

                        await ref
                            .read(reservationSaveProvider.notifier)
                            .saveReservation(newReservation);

                        print("تم حفظ بيانات الحجز.");

                        Navigator.pushNamed(
                          context,
                          Routes.reservationDetails,
                          arguments: newReservation,
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'يرجى التحقق من صحة البيانات وإكمال الحقول المطلوبة'),
                          ),
                        );
                      },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trans().completeTheReservation,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(RoomPrice roomPrice) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = roomPrice;
          _populateEvents(selectedPrice: selectedPrice);
        });
      },
      child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selectedPrice == roomPrice
                ? CustomTheme.primaryColor
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CustomTheme.primaryColor),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //amount
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined,
                        size: 16, color: _getColor(roomPrice)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${roomPrice.amount} ${trans().riyalY}",
                        style: _getTextStyle(roomPrice),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                //period
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: _getColor(roomPrice)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        roomPrice.period,
                        style: _getTextStyle(roomPrice),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                //capacity
                Row(
                  children: [
                    Icon(Icons.groups_2_outlined,
                        size: 16, color: _getColor(roomPrice)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${roomPrice.capacity} ${trans().person}",
                        style: _getTextStyle(roomPrice),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                //deposit
                Row(
                  children: [
                    Icon(Icons.money_off_sharp,
                        size: 16, color: _getColor(roomPrice)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${trans().deposit} ${roomPrice.deposit} ${trans().riyalY}",
                        style: _getTextStyle(roomPrice),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                //time
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16, color: _getColor(roomPrice)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${roomPrice.timeFrom ?? '--:--'} - ${roomPrice.timeTo ?? '--:--'}',
                        style: _getTextStyle(roomPrice),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Color _getColor(RoomPrice roomPrice) {
    return selectedPrice == roomPrice ? Colors.white : CustomTheme.primaryColor;
  }

  TextStyle _getTextStyle(RoomPrice roomPrice) {
    return TextStyle(
      color:
          selectedPrice == roomPrice ? Colors.white : CustomTheme.primaryColor,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: bookingType,
            items: const [
              DropdownMenuItem(
                value: 'Family (Women and Men)',
                child: Text('Family (Women and Men)'),
              ),
              DropdownMenuItem(
                value: 'Women Only',
                child: Text('Women Only'),
              ),
              DropdownMenuItem(
                value: 'Men Only',
                child: Text('Men Only'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                bookingType = value!;
              });
              _saveReservation();
            },
            decoration: InputDecoration(
              labelText: "نوع الحجز",
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: adultsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "عدد الكبار",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _saveReservation(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: childrenController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "عدد الأطفال",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _saveReservation(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return SfDateRangePicker(
        backgroundColor: Colors.white,
        view: DateRangePickerView.month,
        showNavigationArrow: true,
        showTodayButton: false,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (args) {
          final selectedDate = args.value;
          if (events[selectedDate]?.isEmpty ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(trans().dateNotAvailable)),
            );
          } else {
            setState(() {
              this.selectedDay = selectedDate;
            });
          }
        },
        monthViewSettings: DateRangePickerMonthViewSettings(
          dayFormat: 'E',
          specialDates: events.keys.toList(),
          showTrailingAndLeadingDates: false,
          weekendDays: <int>[DateTime.tuesday, DateTime.friday],
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          // specialDatesDecoration: BoxDecoration(
          //   color: Colors.red.withOpacity(0.5),
          //   shape: BoxShape.circle,
          // ),
          specialDatesTextStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.lineThrough,
          ),
          todayTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          todayCellDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ));
  }
}
