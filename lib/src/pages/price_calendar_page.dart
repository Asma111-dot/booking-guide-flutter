import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../models/room_price.dart';
import '../helpers/general_helper.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../models/reservation.dart' as res;

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
  List<RoomPrice> selectedPrices = [];
  RoomPrice? selectedPrice;
  Map<DateTime, List<dynamic>> events = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchRoomPrices();
    });
  }

  // void _fetchRoomPrices() async {
  //   await ref.read(roomPricesProvider.notifier).fetch(roomId: widget.roomId);
  //   setState(() {
  //     events.clear();
  //   });
  //   _populateEvents();
  // }

  void _fetchRoomPrices() async {
    // استدعاء fetch لجلب الأسعار
    await ref.read(roomPricesProvider.notifier).fetch(roomId: widget.roomId);

    // الحصول على قائمة الأسعار من المزود
    final roomPrices = ref.read(roomPricesProvider).data;

    if (roomPrices != null && roomPrices.isNotEmpty) {
      // تعيين أول سعر كافتراضي
      final defaultPrice = roomPrices.first;

      // طباعة السعر الافتراضي للتحقق
      print('Default Price: $defaultPrice');

      // تحديث الأحداث بناءً على السعر الافتراضي
      _populateEvents(selectedPrice: defaultPrice);
    } else {
      // إذا لم تكن هناك أسعار متوفرة
      print('No room prices available');
      setState(() {
        events = {};
      });
    }
  }

  // void _populateEvents({DateTime? startDate, DateTime? endDate}) {
  //    events.clear();
  //   final roomPrices = ref.read(roomPricesProvider).data;
  //   if (roomPrices == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('لا توجد بيانات لأسعار الغرف.')));
  //     return;
  //   }
  //
  //   for (var price in roomPrices) {
  //     final reservations = price.reservations;
  //     for (var reservation in reservations) {
  //       DateTime checkInDate;
  //       DateTime checkOutDate;
  //
  //       if (reservation.checkInDate is String) {
  //         checkInDate = DateTime.parse(reservation.checkInDate as String);
  //       } else
  //         checkInDate = reservation.checkInDate;
  //
  //       if (reservation.checkOutDate is String) {
  //         checkOutDate = DateTime.parse(reservation.checkOutDate as String);
  //       } else
  //         checkOutDate = reservation.checkOutDate;
  //
  //       if ((startDate == null ||
  //               checkInDate.isAfter(startDate) ||
  //               checkInDate.isAtSameMomentAs(startDate)) &&
  //           (endDate == null ||
  //               checkOutDate.isBefore(endDate) ||
  //               checkOutDate.isAtSameMomentAs(endDate))) {
  //         final date = checkInDate;
  //         events[date] = [...(events[date] ?? []), reservation];
  //       }
  //     }
  //   }
  //   setState(() {});
  // }

  void _populateEvents({RoomPrice? selectedPrice}) {
    events.clear();
    final roomPrices = ref.read(roomPricesProvider).data;

    if (roomPrices == null) {
      print('Room prices are null');
      setState(() {
        events = {};
      });
      return;
    }

    if (selectedPrice == null) {
      print('Reservations: ${selectedPrice?.reservations}');
      print('Selected price is null');
      setState(() {
        events = {};
      });
      return;
    }

    print('Selected Price: $selectedPrice');
    print('Reservations: ${selectedPrice.reservations}');

    // معالجة كل الحجز
    for (var reservation in selectedPrice.reservations) {
      try {
        // التحقق من التواريخ
        final checkInDate = reservation.checkInDate is String
            ? DateTime.parse(reservation.checkInDate as String)
            : reservation.checkInDate;
        final checkOutDate = reservation.checkOutDate is String
            ? DateTime.parse(reservation.checkOutDate as String)
            : reservation.checkOutDate;

        print('Processing reservation: $reservation');
        print('Check-in: $checkInDate, Check-out: $checkOutDate');

        // إضافة كل يوم من الحجز إلى قائمة الأحداث
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

    // تحديث الواجهة
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
      body: ViewWidget<List<RoomPrice>>(
        meta: roomPriceState.meta,
        data: roomPriceState.data,
        refresh: () async => await ref
            .read(roomPricesProvider.notifier)
            .fetch(roomId: widget.roomId),
        forceShowLoaded: roomPriceState.data != null,
        onLoaded: (data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Horizontal Price Selector
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.25, // Adjust height dynamically
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: roomPriceState.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final price = roomPriceState.data![index];
                      return _buildPriceCard(price);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    showNavigationArrow: true,
                    showTodayButton: false,
                    selectionMode: DateRangePickerSelectionMode.single,
                    onSelectionChanged: (args) {
                      final selectedDate = args.value;
                      if (events[selectedDate]?.isEmpty ?? true) {
                        setState(() {
                          print('no data');
                          this.selectedDay = selectedDate;
                        });
                      } else {
                        print('has data');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(trans().dateNotAvailable)),
                        );
                      }
                    },
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'd',
                      specialDates: events.keys.toList(),
                      showTrailingAndLeadingDates: false,
                      weekendDays: <int>[DateTime.friday, DateTime.saturday],
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: selectedDay != null && selectedPrice != null
            ? CustomTheme.primaryColor
            : Colors.grey.shade400,
        onPressed: selectedDay != null && selectedPrice != null
            ? () {
                Navigator.pushNamed(
                  context,
                  Routes.reservation,
                  arguments: [res.Reservation.init()] as List<res.Reservation>,
                );
              }
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(trans().selectDateAndPrice)),
                );
              },
        label: Flexible(
          child: Row(
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
    );
  }

  Widget _buildPriceCard(RoomPrice roomPrice) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = roomPrice;
          _populateEvents();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
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
          ],
        ),
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
