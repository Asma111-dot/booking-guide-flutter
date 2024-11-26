import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/auth/user_provider.dart';
import '../providers/reservation/reservations_provider.dart';
import '../helpers/general_helper.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
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
    extends ConsumerState<AvailabilityCalendarPage>//class parent
    with SingleTickerProviderStateMixin {

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
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, Routes.reservation,
            arguments: res.Reservation.init()),
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
            locale: 'ar',
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: DateTime.now(),
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, markersRes) {
                return GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                  ),
                  itemCount: markersRes.length,
                  itemBuilder: (context, index) {
                    final marker = markersRes[index];
                    final isPaid = markersRes[index].payments.isNotEmpty &&
                        markersRes[index].payments
                            .every((payment) => payment.status == 'paid');
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          //   color: isPaid ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'حجز ${markersRes[index].userId}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
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
}
