import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/reservation.dart' as res;
import '../providers/reservation/reservation_provider.dart';
import '../widgets/custom_app_bar.dart';

class ReservationDetailsPage extends ConsumerWidget {
  const ReservationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // احضار بيانات الحجز
    final reservation = ref.watch(reservationProvider).data;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: 'تفاصيل الحجز',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: reservation == null
          ? const Center(
        child: Text(
          'لا توجد تفاصيل للحجز.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الحجز',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // const SizedBox(height: 16),
            // _buildDetailRow("نوع الحضور:", reservation.bookingType),
            // const SizedBox(height: 8),
            // _buildDetailRow("عدد الكبار:", "${reservation.adultsCount}"),
            // const SizedBox(height: 8),
            // _buildDetailRow("عدد الأطفال:", "${reservation.childrenCount}"),
            // const SizedBox(height: 8),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("السابق"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // تأكيد الحجز
                    _confirmReservation(context, reservation);
                  },
                  child: const Text("تأكيد الحجز"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _confirmReservation(BuildContext context, res.Reservation reservation) async {
    // منطق لتأكيد الحجز (إرسال إلى الخادم أو تحديث الحالة)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم تأكيد الحجز برقم ${reservation.id}')),
    );
  }
}
