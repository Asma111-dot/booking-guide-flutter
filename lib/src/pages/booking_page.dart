import 'package:booking_guide/src/models/reservation.dart';
import 'package:booking_guide/src/providers/reservation/reservations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';

class BookingPage extends ConsumerStatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final filter = ref.read(reservationsFilterProvider);
      ref.read(reservationsProvider.notifier).fetch(filter: filter, reset: true);
    });
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'confirmed':
        return 'مؤكد';
      case 'cancelled':
        return 'ملغي';
      case 'pending_payment':
        return 'في انتظار الدفع';
      case 'pending_confirmation':
        return 'في انتظار التأكيد';
      default:
        return 'غير معروف';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending_payment':
        return Colors.orange;
      case 'pending_confirmation':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationsProvider);

    print("📌 reservationState.data: ${reservationState.data}");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().booking,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CustomTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ViewWidget<List<Reservation>>(
        meta: reservationState.meta,
        data: reservationState.data,
        onLoaded: (reservations) {
          print("📌 Data Loaded: $reservations");

          if (reservations == null || reservations.isEmpty) {
            return Center(
              child: Text(
                "لا توجد حجز حالياً",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final placeName = reservation.roomPrice?.room?.name ?? '---';
              final imageUrl =
                  reservation.roomPrice?.room?.media ?? ''; // تأكد من وجوده

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // صورة المنشأة
                      if (reservation.roomPrice?.room?.facility?.logo !=
                          null) ...[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(
                                  reservation.roomPrice!.room!.facility!.logo!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // بيانات الحجز
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                placeName,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${reservation.checkInDate.toLocal().toString().split(' ')[0]}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "#${reservation.id}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // السعر
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${reservation.totalPrice?.toStringAsFixed(0) ?? '--'} ريال",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(reservation.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStatusText(reservation.status),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
