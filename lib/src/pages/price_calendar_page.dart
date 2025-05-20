import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/reservation.dart';
import '../models/room_price.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/booked_dates_from_google_calendar_provider.dart';
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
        events = {}; // ⬅️ لا توجد أحداث لأن السعر لم يُحدد بعد
      });
    } else {
      setState(() {
        events = {};
      });
    }
  }

  void _populateEvents({
    required RoomPrice selectedPrice,
    required List<Map<String, dynamic>> bookedDates,
  }) {
      debugPrint('📌 بدء معالجة الأحداث للسعر: ${selectedPrice.id}');
    final Map<DateTime, List<dynamic>> tempEvents = {};

    // ✅ حجوزات النظام
    for (var reservation in selectedPrice.reservations) {
      try {
        if (reservation.status != 'confirmed') continue;

        final checkInDate = DateTime.parse(reservation.checkInDate.toString());
        final checkOutDate = DateTime.parse(reservation.checkOutDate.toString());

        DateTime currentDate = checkInDate;
        while (currentDate.isBefore(checkOutDate) ||
            currentDate.isAtSameMomentAs(checkOutDate)) {
          final normalized = DateTime(currentDate.year, currentDate.month, currentDate.day);
          tempEvents[normalized] = [...(tempEvents[normalized] ?? []), reservation];
          currentDate = currentDate.add(const Duration(days: 1));
        }
      } catch (e) {
        debugPrint('❌ خطأ أثناء معالجة الحجز: $e');
      }
    }

    // ✅ 2. تواريخ Google Calendar
    // final bookedDates = ref.read(reservationsProvider.notifier).bookedDates;
    // for (final dateStr in bookedDates) {
    //   try {
    //     final date = DateTime.parse(dateStr);
    //     // events[date] = [...(events[date] ?? []), 'محجوز من Google Calendar'];
    //     events[date] = [...(events[date] ?? []), {'type': 'google', 'label': 'محجوز من Google Calendar'}];
    //   } catch (e) {
    //     debugPrint('Invalid date from Google Calendar: $dateStr');
    //   }
    // }
    for (final item in bookedDates) {
      try {
        debugPrint('🔁 فحص عنصر جديد من Google Calendar: $item');

        if (!item.containsKey('date') || !item.containsKey('period')) {
          debugPrint('❌ عنصر غير مكتمل: $item');
          continue;
        }

        final rawDate = item['date'];
        final rawPeriod = item['period'];
        final selectedRawPeriod = selectedPrice.period;

        if (rawDate == null || rawDate.toString().trim().isEmpty) {
          debugPrint('❌ تاريخ غير صالح: $item');
          continue;
        }

        final period = rawPeriod.toString().trim().toLowerCase();
        final selectedPeriod = selectedRawPeriod.toString().trim().toLowerCase();

        debugPrint('🔍 المقارنة الأصلية: "$rawPeriod" == "$selectedRawPeriod"');
        debugPrint('🔍 بعد التنسيق: "$period" == "$selectedPeriod"');

        final parsed = DateTime.parse(rawDate);
        final date = DateTime(parsed.year, parsed.month, parsed.day);

        if (period == selectedPeriod) {
          tempEvents[date] = [
            ...(tempEvents[date] ?? []),
            {
              'type': 'google',
              'label': 'محجوز: $rawPeriod',
            }
          ];
          debugPrint('📅 تمت إضافة Google Calendar: $date => محجوز: $rawPeriod');
        } else {
          debugPrint('🕵️‍♂️ تجاهل التاريخ $date لأن الفترة ($period) ≠ ($selectedPeriod)');
        }
      } catch (e) {
        debugPrint('❌ خطأ في تحليل التاريخ من Google Calendar: $e');
      }
    }

    events = tempEvents;
    debugPrint('✅ عدد التواريخ المحجوزة: ${events.length}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);
    final bookedDates = ref.watch(bookedDatesFromGoogleCalendarProvider);

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
                            onTap: () async {
                              setState(() {
                                selectedPrice = roomPrice;
                              });

                              final facilityId = roomPrice.room?.facility?.id ?? roomPrice.room?.facilityId;
                              if (facilityId == null || facilityId == 0) {
                                print("❌ facilityId غير موجود، لا يمكن جلب التواريخ المحجوزة");
                                return;
                              }

                              await ref.read(bookedDatesFromGoogleCalendarProvider.notifier).fetch(facilityId);
                              final googleBookedDates = ref.read(bookedDatesFromGoogleCalendarProvider);
                              _populateEvents(
                                selectedPrice: roomPrice,
                                bookedDates: googleBookedDates,
                              );
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
                    key: ValueKey('${selectedPrice?.id}-${DateTime.now().millisecondsSinceEpoch}'),
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
                  )
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
