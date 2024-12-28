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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchRoomPrices();
    });
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

    ref.read(formProvider.notifier).updateField(
      id: 0,
      roomPriceId: selectedPrice.id,
      checkInDate: DateTime.now(),
      checkOutDate: DateTime.now(),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);
    final reservationSaveState = ref.watch(formProvider);

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
              return Column(
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
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _buildPriceCard(roomPrice),
                        );
                      },
                    ),
                  ),

                  // calender
                  const SizedBox(height: 30),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SfDateRangePicker(
                      backgroundColor: Colors.white,
                      view: DateRangePickerView.month,
                      showNavigationArrow: true,
                      showTodayButton: false,
                      selectionMode: DateRangePickerSelectionMode.single,
                      onSelectionChanged: (args) {
                        final selectedDate = args.value;
                        if (events[selectedDate]?.isEmpty ?? true) {
                          setState(() {
                            this.selectedDay = selectedDate;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(trans().dateNotAvailable)),
                          );
                        }
                      },
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: 'E',
                        specialDates: events.keys.toList(),
                        showTrailingAndLeadingDates: false,
                        weekendDays: <int>[DateTime.tuesday, DateTime.friday],
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        specialDatesDecoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        specialDatesTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        todayTextStyle: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        todayCellDecoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                backgroundColor: selectedDay != null && selectedPrice != null
                    ? CustomTheme.primaryColor
                    : Colors.grey.shade400,
                onPressed: selectedDay != null && selectedPrice != null
                    ? () async {
                  ref.read(formProvider.notifier).updateField(
                    id: 0,
                    roomPriceId: selectedPrice!.id,
                    checkInDate: selectedDay,
                    checkOutDate: selectedDay,
                  );
                  print('Saving reservation draft...');
                  print('Room Price ID: ${selectedPrice!.id}');
                  print('Check-In Date: ${selectedDay}');
                  print('Check-Out Date: ${selectedDay}');

                  await ref
                      .read(reservationSaveProvider.notifier)
                      .saveReservationDraft(reservationSaveState);

                  Navigator.pushNamed(
                    context,
                    Routes.reservation,
                    arguments: selectedPrice,
                  );
                }
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى اختيار السعر واليوم أولاً'),
                    ),
                  );
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trans().continueBooking,
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
                  Icon(Icons.access_time, size: 16, color: _getColor(roomPrice)),
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

        )
      ),
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
}
