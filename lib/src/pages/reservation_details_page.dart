import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/routes.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/reservation_details_content.dart';
import '../widgets/view_widget.dart';

class ReservationDetailsPage extends ConsumerStatefulWidget {
  final int reservationId;

  const ReservationDetailsPage({
    super.key,
    required this.reservationId,
  });

  @override
  ConsumerState<ReservationDetailsPage> createState() =>
      _ReservationDetailsPageState();
}

class _ReservationDetailsPageState
    extends ConsumerState<ReservationDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(reservationProvider.notifier)
          .fetch(reservationId: widget.reservationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarClipper(
        title: trans().reservationDetails,
      ),
      resizeToAvoidBottomInset: true,
      body: ViewWidget<res.Reservation>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationProvider.notifier)
            .fetch(reservationId: widget.reservationId),
        forceShowLoaded: reservationState.data != null,
        onLoaded: (data) => ReservationDetailsContent(data: data),
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ⚠️ ملاحظة تنبيه للمستخدم
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      trans().booking_not_confirmed_warning,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 🔙 زر التراجع
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.navigationMenu,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.arrow_back),
              label: Text(trans().go_back),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            const SizedBox(height: 12),

            // 💳 زر الدفع
            Button(
              width: double.infinity,
              title: trans().payment_now,
              icon: const Icon(Icons.arrow_forward,
                  size: 20, color: Colors.white),
              iconAfterText: true,
              disable: false,
              onPressed: () async {
                Navigator.pushNamed(
                  context,
                  Routes.payment,
                  arguments: reservationState.data?.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
