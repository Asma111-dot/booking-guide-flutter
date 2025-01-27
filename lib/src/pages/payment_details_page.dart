import 'package:booking_guide/src/extensions/date_formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/payment.dart' as p;
import '../providers/payment/payment_provider.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/custom_row_widget.dart';
import '../widgets/view_widget.dart';

class PaymentDetailsPage extends ConsumerStatefulWidget {
  final int paymentId;

  PaymentDetailsPage({required this.paymentId});

  @override
  ConsumerState<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends ConsumerState<PaymentDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final response = await ref
          .read(paymentProvider.notifier)
          .fetch(paymentId: widget.paymentId);
      print("Response: $response");
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: CustomAppBarClipper(
          backgroundColor: CustomTheme.primaryColor,
          height: 160.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 200.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    trans().payment_details,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ViewWidget<p.Payment>(
        meta: paymentState.meta,
        data: paymentState.data,
        refresh: () async => await ref
            .read(paymentProvider.notifier)
            .fetch(paymentId: widget.paymentId),
        forceShowLoaded: paymentState.data != null,
        onLoaded: (data) {
          final reservation = data.reservation;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  CustomRowWidget(
                    icon: Icons.money,
                    label: trans().price,
                    value: "${data.amount.toInt()} ${trans().riyalY}",
                  ),
                  CustomRowWidget(
                    icon: Icons.date_range,
                    label: trans().payment_date,
                    value: "${data.date.toDateView()}",
                  ),
                  CustomRowWidget(
                    icon: Icons.payment,
                    label: trans().status,
                    value: (data.status),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  Text(
                    trans().reservationDetails,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (reservation != null) ...[
                    CustomRowWidget(
                      icon: Icons.room,
                      label: "اسم الشالية",
                      value: reservation.roomPrice?.room?.name ??
                          trans().not_available,
                    ),
                    CustomRowWidget(
                      icon: Icons.calendar_today,
                      label: "تاريخ الدخول",
                      value: reservation.checkInDate.toDateDateView(),
                    ),
                    CustomRowWidget(
                      icon: Icons.calendar_today,
                      label: "تاريخ الخروج",
                      value: reservation.checkOutDate.toDateDateView(),
                    ),
                    CustomRowWidget(
                      icon: Icons.people,
                      label: trans().adults_count,
                      value: "${reservation.adultsCount}",
                    ),
                    CustomRowWidget(
                      icon: Icons.child_care,
                      label: trans().children_count,
                      value: "${reservation.childrenCount}",
                    ),
                    CustomRowWidget(
                      icon: Icons.money,
                      label: trans().total_price,
                      value: "${reservation.totalPrice} ${trans().riyalY}",
                    ),
                  ] else
                    Text(trans().not_available),
                ],
              ),
            ),
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(
          child: Text(trans().no_data),
        ),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
