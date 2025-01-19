import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/view_widget.dart';
import 'payment_page.dart'; // استيراد صفحة الدفع

class ReservationDetailsPage extends ConsumerStatefulWidget {
  final int roomPriceId;

  const ReservationDetailsPage({
    Key? key,
    required this.roomPriceId,
  }) : super(key: key);

  @override
  ConsumerState<ReservationDetailsPage> createState() =>
      _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends ConsumerState<ReservationDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reservationProvider.notifier).fetch(roomPriceId: widget.roomPriceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reservationState = ref.watch(reservationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: CustomAppBarClipper(
          backgroundColor: CustomTheme.primaryColor,
          height: 160.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 90.0),
              child: Text(
                trans().reservationDetails,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ViewWidget<res.Reservation>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationProvider.notifier)
            .fetch(roomPriceId: widget.roomPriceId),
        forceShowLoaded: reservationState.data != null,
        onLoaded: (data) {
          return Stack(
            children: [
              // محتوى الصفحة داخل Column
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.roomPrice?.room?.facility?.logo != null) ...[
                      Center(
                        child: Image.network(
                          data.roomPrice!.room!.facility!.logo!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Text(
                      "اسم الشاليه: ${data.roomPrice?.room?.facility?.name ?? 'غير متوفر'}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "العنوان : ${data.roomPrice?.room?.facility?.address ?? 'غير متوفر'}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // تفاصيل الحجز
                    Text("تاريخ الدخول: ${data.checkInDate}", style: const TextStyle(fontSize: 16)),
                    Text("تاريخ الخروج: ${data.checkOutDate}", style: const TextStyle(fontSize: 16)),
                    Text("نوع الحجز: ${data.bookingType}", style: const TextStyle(fontSize: 16)),
                    Text("عدد البالغين: ${data.adultsCount}", style: const TextStyle(fontSize: 16)),
                    Text("عدد الأطفال: ${data.childrenCount}", style: const TextStyle(fontSize: 16)),
                    Text("السعر الإجمالي: ${data.totalPrice} ريال", style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              // الزر الثابت في أسفل الشاشة
              Positioned(
                bottom: 20,  // المسافة من الأسفل
                left: 20,
                right: 20,
                child: Button(
                  width: MediaQuery.of(context).size.width - 40,
                  title: "الدفع الآن",
                  disable: false, // تحديد ما إذا كان الزر مفعلًا أو لا
                  onPressed: ()async {
                    // الانتقال إلى صفحة الدفع مع تمرير بيانات الحجز
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(reservation: data),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () =>  Center(
          child: Text(trans().no_data),
        ),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
