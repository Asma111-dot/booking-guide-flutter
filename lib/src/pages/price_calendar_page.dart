import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/auth/user_provider.dart';
import '../providers/reservation/reservations_provider.dart';
import '../helpers/general_helper.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';
import '../models/reservation.dart' as res;
import '../models/user.dart' as model;

class PriceAndCalendarPage extends ConsumerStatefulWidget {
  final List<res.Reservation> reservations;

  const PriceAndCalendarPage({Key? key, required this.reservations})
      : super(key: key);

  @override
  _AvailabilityCalendarPageState createState() =>
      _AvailabilityCalendarPageState();
}

class _AvailabilityCalendarPageState
    extends ConsumerState<PriceAndCalendarPage> //class parent
    with
        SingleTickerProviderStateMixin {
  model.User user() => ref.read(userProvider).data!;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reservationsProvider(user()).notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationsProvider(user()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().availabilityCalendar,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CustomTheme.primaryColor,
        onPressed: () => Navigator.pushNamed(
          context,
          Routes.reservation,
          arguments: [res.Reservation.init()],
        ),
        label: Row(
          children: [
            Text(
              trans().next,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ViewWidget<List<res.Reservation>>(
              meta: reservationState.meta,
              data: reservationState.data,
              refresh: () async => await ref
                  .read(reservationsProvider(user()).notifier)
                  .fetch(reset: true),
              forceShowLoaded: reservationState.data?.isNotEmpty ?? false,
              onLoaded: (data) {
                var _events = _generateEvents(data);
                // print('Generated Events: $_events');

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "الأيام المتاح",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "اختر التاريخ المتاح للحجز من خلال التقويم.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomTheme.primaryColor),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TableCalendar<res.Reservation>(
                        locale: 'ar',
                        firstDay: DateTime.now().subtract(Duration(days: 365)),
                        lastDay: DateTime.now().add(Duration(days: 365)),
                        focusedDay: DateTime.now(),
                        selectedDayPredicate: (day) {
                          return _events.keys
                              .any((eventDay) => isSameDay(eventDay, day));
                        },
                        eventLoader: (day) {
                          return _events[day] ?? [];
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, markersRes) {
                            if (_events.keys
                                .any((eventDay) => isSameDay(eventDay, date))) {
                              if (markersRes.isEmpty) return SizedBox();

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: markersRes.map((marker) {
                                  final bool isPaid =
                                      marker.payments.isNotEmpty &&
                                          marker.payments.every((payment) =>
                                              payment.status == 'paid');

                                  final bool isPaymentNull = marker
                                          .payments.isEmpty ||
                                      marker.payments.any(
                                          (payment) => payment.status == null);

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? Colors.green
                                          : isPaymentNull
                                              ? Colors.red
                                              : Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                          disabledBuilder: (context, date, focusedDay) {
                            if (_isDateReserved(date)) {
                              return Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "باقة الأسعار ",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "تعرّف على الأسعار المختلفة للحجز.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildPriceCard('السعر 1', '1000 ريال'),
                          _buildPriceCard('السعر 2', '1500 ريال'),
                          _buildPriceCard('السعر 3', '2000 ريال'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          //       Positioned(
          //         bottom: 20,
          //           left: 20,
          //           right: 20,
          //           child: FloatingActionButton.extended(
          //       backgroundColor: CustomTheme.primaryColor,
          //       onPressed: () => Navigator.pushNamed(
          //       context,
          //       Routes.reservation,
          //       arguments: [res.Reservation.init()],
          //       ),
          //       label: Row(
          //       children: [
          //       Text(
          //       trans().next,
          //       style: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //       ),
          //       ),
          //       const SizedBox(width: 8),
          //       const Icon(Icons.arrow_forward),
          // ],
          // ),
          // ),
          // )
        ],
      ),
    );
  }

  bool _isDateReserved(DateTime date) {
    return widget.reservations.any((reservation) =>
        date.isAtSameMomentAs(reservation.checkInDate) ||
        (date.isAfter(reservation.checkInDate) &&
            date.isBefore(reservation.checkOutDate)));
  }
}

Map<DateTime, List<res.Reservation>> _generateEvents(
    List<res.Reservation> reservations) {
  final Map<DateTime, List<res.Reservation>> events = {};
  for (var reservation in reservations) {
    for (var day in _getReservationDays(reservation)) {
      if (!events.containsKey(day)) {
        events[day] = [];
      }
      events[day]?.add(reservation);
    }
  }
  return events;
}

List<DateTime> _getReservationDays(res.Reservation reservation) {
  final List<DateTime> days = [];
  DateTime current = reservation.checkInDate;
  while (!current.isAfter(reservation.checkOutDate)) {
    days.add(current);
    current = current.add(const Duration(days: 1));
  }
  return days;
}

Widget _buildPriceCard(String title, String price) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: CustomTheme.primaryColor),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: TextStyle(fontSize: 14, color: Colors.green),
        ),
      ],
    ),
  );
}
