import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/general_helper.dart';
import '../models/reservation.dart' as res;
import '../widgets/custom_app_bar.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final res.Reservation reservation;

  const PaymentPage({
    Key? key,
    required this.reservation,
  }) : super(key: key);

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: trans().availabilityCalendar,
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("تفاصيل الحجز:"),
            Text("اسم الشاليه: ${widget.reservation.roomPrice?.room?.facility?.name ?? 'غير متوفر'}"),
            Text("السعر الإجمالي: ${widget.reservation.totalPrice} ريال"),
            SizedBox(height: 20),
            Text("اختيار طريقة الدفع:"),
            // إضافة خيارات الدفع
            ElevatedButton(
              onPressed: () {
                _handlePayment();
              },
              child: Text("الدفع عبر المحفظة الإلكترونية"),
            ),
          ],
        ),
      ),
    );
  }

  // دالة الدفع
  void _handlePayment() {
    // هنا سيتم تنفيذ الدفع مع المحفظة الإلكترونية مثل PayPal أو Stripe
    // يمكن استدعاء خدمة الدفع هنا وإتمام المعاملة
  }
}
