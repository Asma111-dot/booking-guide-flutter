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
import '../utils/sizes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_calendar_widget.dart';
import '../widgets/room_price_shimmer_card.dart';
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
  bool useRange = true;
  DateTime? someDate = DateTime.now();

  bool isSamePeriod(String roomPeriod, String googlePeriod) {
    return norm(roomPeriod) == norm(googlePeriod);
  }

  String norm(String s) {
    final t = s.trim().toLowerCase().replaceAll(' ', '');

    if (t.contains('صباح')) return 'صباحية';
    if (t.contains('مساء')) return 'مسائية';
    if (t.contains('ليل')) return 'ليلية';

    if (t.contains('كامل')) return 'كامل';

    if (t.contains('نصف')) return 'نصف يوم';

    return t;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchRoomPrices();
    });
  }

  void _fetchRoomPrices() async {
    await ref.read(roomPricesProvider.notifier).fetch(roomId: widget.roomId);

    setState(() {
      selectedPrice = null;
      events = {};
      rangeStart = null;
      rangeEnd = null;
    });
  }

  void _populateEvents({
    required RoomPrice selectedPrice,
    required List<Map<String, dynamic>> bookedDates,
  }) {
    final Map<DateTime, List<dynamic>> tempEvents = {};

    final roomPeriod = selectedPrice.period;

    // ===============================
    // 1️⃣ حجوزات النظام (تشطب دائمًا)
    // ===============================
    for (final reservation in selectedPrice.reservations) {
      final start = DateUtils.dateOnly(
        DateTime.parse(reservation.checkInDate.toString()).toLocal(),
      );
      final end = DateUtils.dateOnly(
        DateTime.parse(reservation.checkOutDate.toString()).toLocal(),
      );

      for (DateTime d = start;
          !d.isAfter(end);
          d = d.add(const Duration(days: 1))) {
        tempEvents.putIfAbsent(d, () => []);
        tempEvents[d]!.add('system');
      }
    }

    // ===============================
    // 2️⃣ Google Calendar (تطابق period فقط)
    // ===============================
    for (final item in bookedDates) {
      if (item['date'] == null || item['period'] == null) continue;

      // 🔴 الشرط الوحيد
      if (!isSamePeriod(roomPeriod, item['period'])) continue;

      final date = DateUtils.dateOnly(
        DateTime.parse(item['date']).toLocal(),
      );
      debugPrint(
          '🧪 compare → room=${norm(roomPeriod)} | google=${norm(item['period'])}');

      tempEvents.putIfAbsent(date, () => []);
      tempEvents[date]!.add('google');
    }

    debugPrint('🔥 Final events: $tempEvents');

    setState(() {
      events = tempEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
        forceShowLoaded: true,
        onLoaded: (data) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Insets.s12, vertical: S.h(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trans().view_price_list,
                          style: TextStyle(
                            fontSize: TFont.s12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Gaps.h4,
                        // Text(
                        //   trans().select_period_and_day,
                        //   style: TextStyle(
                        //     fontSize: TFont.xxs10,
                        //     fontWeight: FontWeight.w400,
                        //     color: theme.colorScheme.onSurface.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: S.h(200),
                    child: (data.isEmpty)
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: S.w(2),
                                vertical: S.h(10),
                              ),
                              child: const RoomPriceShimmerCard(),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final roomPrice = data[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: S.w(4),
                                  vertical: S.h(14),
                                ),
                                child: RoomPriceWidget(
                                    roomPrice: roomPrice,
                                    isSelected: selectedPrice == roomPrice,
                                    onTap: () async {
                                      if (selectedPrice?.id == roomPrice.id)
                                        return;

                                      setState(() {
                                        selectedPrice = roomPrice;
                                        events = {};
                                        rangeStart = null;
                                        rangeEnd = null;
                                      });

                                      final facilityId = roomPrice.facilityId;
                                      if (facilityId == null || facilityId == 0)
                                        return;

                                      final googleBookedDates = await ref
                                          .read(
                                              bookedDatesFromGoogleCalendarProvider
                                                  .notifier)
                                          .fetch(facilityId);

                                      _populateEvents(
                                        selectedPrice: roomPrice,
                                        bookedDates: googleBookedDates,
                                      );
                                    }),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.m16,
                      vertical: S.h(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trans().question_title,
                          style: TextStyle(
                            fontSize: TFont.s12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Gaps.h4,
                        // Text(
                        //   trans().question_description,
                        //   style: TextStyle(
                        //     fontSize: TFont.xxs10,
                        //     fontWeight: FontWeight.w400,
                        //     color: theme.colorScheme.onSurface.withOpacity(0.6),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  CustomCalendarWidget(
                    key: ValueKey(selectedPrice?.id),
                    events: {
                      for (var e in events.entries)
                        DateUtils.dateOnly(e.key): ['booked'],
                    },
                    selectionType:
                        useRange ? SelectionType.range : SelectionType.single,
                    initialSelectedDay: useRange ? null : someDate,
                    initialSelectedRange:
                        useRange && rangeStart != null && rangeEnd != null
                            ? DateTimeRange(start: rangeStart!, end: rangeEnd!)
                            : null,
                    onSingleDateSelected: (date) {
                      setState(() {
                        rangeStart = date;
                        rangeEnd = date;
                      });
                    },
                    onRangeSelected: (range) {
                      setState(() {
                        rangeStart = range.start;
                        rangeEnd = range.end;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Button(
            width: double.infinity,
            title: trans().continueBooking,
            icon: Icon(
              arrowForWordIcon,
              size: Sizes.iconM20,
              color: theme.colorScheme.surface,
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

                Navigator.pushNamed(
                  context,
                  Routes.reservation,
                  arguments: selectedPrice,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(trans().pleaseSelectPeriodAndPriceFirst),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
