import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reservation.dart';
import '../models/room_price.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_save_provider.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_calendar_widget.dart';
import '../widgets/room_price_two_widget.dart';
import '../widgets/view_widget.dart';

class PriceAndCalendarPage extends ConsumerStatefulWidget {
  final int roomId;

  const PriceAndCalendarPage({super.key, required this.roomId});

  @override
  ConsumerState<PriceAndCalendarPage> createState() =>
      _PriceAndCalendarPageState();
}

class _PriceAndCalendarPageState extends ConsumerState<PriceAndCalendarPage> {
  RoomPrice? selectedPrice;
  Map<DateTime, List<dynamic>> events = {};
  bool hasSuccessfulAttempt = false;
  DateTime? rangeStart;
  DateTime? rangeEnd;

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
      setState(() {
        selectedPrice = null;
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
        debugPrint('Error processing reservation: $e');
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
        icon: arrowBackIcon,
      ),
      body: ViewWidget<List<RoomPrice>>(
        meta: roomPriceState.meta,
        data: roomPriceState.data,
        refresh: () async => await ref
            .read(roomPricesProvider.notifier)
            .fetch(roomId: widget.roomId),
        forceShowLoaded: roomPriceState.data != null,
        onLoaded: (data) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والوصف
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trans().view_price_list,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trans().select_period_and_day,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // قائمة الفترات بشكل أفقي
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final roomPrice = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 14.0),
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

                  // نص توضيحي
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trans().question_title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trans().question_description,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // تقويم الحجوزات
                  CustomCalendarWidget(
                    events: events.map((key, value) =>
                        MapEntry(key, value.map((e) => e.toString()).toList())),
                    selectionType: SelectionType.range,
                    initialSelectedDay: null,
                    onSingleDateSelected: (date) {
                      print("Selected single date: $date");
                    },
                    onRangeSelected: (range) {
                      setState(() {
                        rangeStart = range.start;
                        rangeEnd = range.end;
                      });
                      print("Selected range: ${range.start} to ${range.end}");
                    },
                  ),
                ],
              ),
            ),
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Button(
          width: double.infinity,
          title: trans().continueBooking,
          icon: Icon(
            arrowForWordIcon,
            size: 20,
            color: Colors.white,
          ),
          iconAfterText: true,
          disable: (rangeStart == null ||
                  rangeEnd == null ||
                  selectedPrice == null) &&
              !hasSuccessfulAttempt,
          onPressed: () async {
            if (rangeStart != null &&
                rangeEnd != null &&
                selectedPrice != null) {
              setState(() {
                hasSuccessfulAttempt = true;
              });

              ref.read(reservationSaveProvider.notifier).saveReservationDraft(
                    Reservation(
                      roomPriceId: selectedPrice!.id,
                      checkInDate: rangeStart!,
                      checkOutDate: rangeEnd!,
                      id: 0,
                      bookingType: '',
                    ),
                  );

              Navigator.pushNamed(context, Routes.reservation,
                  arguments: selectedPrice);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('يرجى اختيار فترة وتحديد السعر أولاً'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
