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

class AvailabilityCalendarPage extends ConsumerStatefulWidget {
  final List<res.Reservation> reservations;

  const AvailabilityCalendarPage({Key? key, required this.reservations})
      : super(key: key);

  @override
  _AvailabilityCalendarPageState createState() =>
      _AvailabilityCalendarPageState();
}

class _AvailabilityCalendarPageState
    extends ConsumerState<AvailabilityCalendarPage> //class parent
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
      body: ViewWidget<List<res.Reservation>>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationsProvider(user()).notifier)
            .fetch(reset: true),
        forceShowLoaded: reservationState.data?.isNotEmpty ?? false,
        onLoaded: (data) {
          var _events = _generateEvents(data);
          return TableCalendar<res.Reservation>(
            // headerStyle: HeaderStyle(
            //     decoration: BoxDecoration(
            //       color: CustomTheme.primaryColor,
            //     ),
            //     headerMargin: const EdgeInsets.only(bottom: 8.0),
            //     titleTextStyle: TextStyle(
            //       color: Colors.white,
            //     ),
            //     formatButtonDecoration: BoxDecoration(
            //         border: Border.all(color: Colors.white),
            //         borderRadius: BorderRadius.circular(0.8))),
            locale: 'ar',
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: DateTime.now(),
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, markersRes) {
                if (markersRes.isEmpty) return SizedBox();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: markersRes.map((marker) {
                    final bool isPaid = marker.payments.isNotEmpty &&
                        marker.payments
                            .every((payment) => payment.status == 'paid');

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isPaid ? Colors.green : Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                );
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
                }
                return null;
              },
            ),
          );
        },
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
