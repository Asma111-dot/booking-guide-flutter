import 'package:booking_guide/src/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/room_price.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_calendar_widget.dart';
import '../widgets/room_price_two_widget.dart';
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
  RoomPrice? selectedPrice;
  Map<DateTime, List<dynamic>> events = {};
  bool hasSuccessfulAttempt = false;

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
      setState(() {
        selectedPrice = defaultPrice;  // Ensure there's a default price
      });
      _populateEvents();
    } else {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);

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
                            child: RoomPriceWidget(
                              roomPrice: roomPrice,
                              isSelected: selectedPrice == roomPrice,
                              onTap: () {
                                setState(() {
                                  selectedPrice = roomPrice;
                                  _populateEvents(selectedPrice: selectedPrice);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomCalendarWidget(
                      events: events.map((key, value) {
                        return MapEntry(key, value.map((e) => e.toString()).toList());
                      }),
                      initialSelectedDay: selectedDay,
                      onDateSelected: (DateTime selectedDate) {
                        setState(() {
                          selectedDay = selectedDate;
                        });
                        if (events[selectedDate] == null || events[selectedDate]!.isEmpty) {
                          print('Selected date: $selectedDate');
                          print('Events: ${events[selectedDate]}');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
            onLoading: () => const Center(child: CircularProgressIndicator()),
            onEmpty: () =>  Center(
              child: Text(trans().no_data),
            ),
            showError: true,
            showEmpty: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Button(
                width: double.infinity,
                title: trans().continueBooking,
                disable: (selectedDay == null ||
                    selectedPrice == null ||
                    (events[selectedDay]?.isNotEmpty ?? false)) && !hasSuccessfulAttempt,
                onPressed: () async {
                  if (selectedDay != null &&
                      selectedPrice != null &&
                      !(events[selectedDay]?.isNotEmpty ?? false)) {
                    setState(() {
                      hasSuccessfulAttempt = true;
                    });

                    print("Selected Day: $selectedDay");
                    print("Selected Price: $selectedPrice");

                    ref.read(reservationSaveProvider.notifier).saveReservationDraft(
                      Reservation(
                        roomPriceId: selectedPrice!.id,
                        checkInDate: selectedDay!,
                        checkOutDate: selectedDay!,
                        id: 0,
                        bookingType: '',
                      ),
                    );

                    Navigator.pushNamed(context, Routes.reservation, arguments: selectedPrice);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى اختيار يوم وسعر غير محجوزين أولاً'),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
