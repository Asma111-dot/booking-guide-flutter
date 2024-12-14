import 'package:booking_guide/src/providers/room_price/room_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/room_price.dart' as price;
import '../helpers/general_helper.dart';
import '../providers/room_price/room_prices_provider.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../models/reservation.dart' as res;
import '../models/user.dart' as model;

class PriceAndCalendarPage extends ConsumerStatefulWidget {
  final List<price.RoomPrice> roomPrices;

  const PriceAndCalendarPage({Key? key, required this.roomPrices})
      : super(key: key);

  @override
  ConsumerState createState() => _AvailabilityCalendarPageState();
}

class _AvailabilityCalendarPageState
    extends ConsumerState<PriceAndCalendarPage> {
  Map<DateTime, List<res.Reservation>> events = {};
  DateTime? selectedDay;
  List<price.RoomPrice> selectedPrices = [];
  price.RoomPrice? selectedPrice;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations({int? roomPriceId}) async {
    events.clear();
    final state = ref.read(roomPricesProvider);
    if (state.data != null) {
      for (final roomPrice in state.data!) {
        if (roomPriceId != null && roomPrice.id != roomPriceId) continue;

        final reservations = await fetchReservations(roomPrice.id);
        for (final res in reservations) {
          final date = DateTime.parse(res.checkInDate as String);
          if (events[date] == null) events[date] = [];
          events[date]?.add(res);
        }
      }
      setState(() {});
      if (selectedPrices.isNotEmpty) {
        ref.read(roomPricesProvider.notifier).fetch(
          roomPriceId: selectedPrices.first.id,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomPriceState = ref.watch(roomPricesProvider);
    if (roomPriceState.isLoaded()) {
      print("Loading prices...");
    }
    if (roomPriceState.isError()) {
      print("Error loading prices: ${roomPriceState}");
    }
    if (roomPriceState.data != null) {
      print("Loaded prices: ${roomPriceState.data}");
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().availabilityCalendar,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Column(
        children: [
          Expanded(
              child: ViewWidget<List<price.RoomPrice>>(
                meta: roomPriceState.meta,
                data: roomPriceState.data,
                forceShowLoaded: true,
                onLoaded: (data) {
                  // selectedPrices = data;
                  // return Text('hello');

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final roomPrice = data[index];
                      return _buildPriceCard(roomPrice);
                    },
                  );
                },
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TableCalendar<res.Reservation>(
              locale: 'ar',
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(selectedDay, day),
              eventLoader: (day) => events[day] ?? [],
              onDaySelected: (selectedDay, focusedDay) {
                if (events[selectedDay]?.isEmpty ?? true) {
                  setState(() {
                    this.selectedDay = selectedDay;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(trans().dateNotAvailable)));
                }
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  final isBooked = events[day]?.isNotEmpty ?? false;
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isBooked
                          ? Colors.red.withOpacity(0.5)
                          : CustomTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color:
                        isBooked ? Colors.white : CustomTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
            arguments: [res.Reservation.init(), selectedPrice],
          );
        }
            : () {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(trans().selectDateAndPrice)));
        },
        label: Row(
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
        //await ref.read(roomPriceProvider.notifier).submit();
    ],
        ),
      ),
    );
  }

  Future<List<res.Reservation>> fetchReservations(int roomPriceId) async {
    final response = await ref.read(roomPricesProvider.notifier).fetch(
      roomPriceId: roomPriceId,
    );
    return response.data ?? [];
  }
  Widget _buildPriceCard(price.RoomPrice roomPrice) {
    print('Building card for: ${roomPrice.id}');
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPrice = roomPrice;
          _loadReservations(roomPriceId: roomPrice.id);
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selectedPrice == roomPrice
              ? CustomTheme.primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CustomTheme.primaryColor),
        ),
        child: Column(
          children: [
            Text(
              roomPrice.period,
              style: TextStyle(
                color: selectedPrice == roomPrice
                    ? Colors.white
                    : CustomTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${roomPrice.amount} ${roomPrice.currency}',
              style: TextStyle(
                color: selectedPrice == roomPrice
                    ? Colors.white
                    : CustomTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPriceCard(price.RoomPrice roomPrice) {
  //   final isSelected = selectedPrice == roomPrice;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedPrice = roomPrice;
  //         _loadReservations(roomPriceId: roomPrice.id);
  //       });
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 6),
  //       padding: const EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         color: isSelected ? CustomTheme.primaryColor : Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: CustomTheme.primaryColor),
  //       ),
  //       child: Column(
  //         children: [
  //           Text(
  //             roomPrice.period,
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : CustomTheme.primaryColor,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             '${roomPrice.amount} ${roomPrice.currency}',
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : CustomTheme.primaryColor,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
