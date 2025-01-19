import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/view_widget.dart';

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
      appBar: CustomAppBar(
        appTitle: trans().reservationDetails,
       // icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: ViewWidget<res.Reservation>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationProvider.notifier)
            .fetch(roomPriceId: widget.roomPriceId),
        forceShowLoaded: reservationState.data != null,
        onLoaded: (data) {
          return Padding(
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
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => const Center(
          child: Text(
            "لا توجد بيانات",
            style: TextStyle(color: CustomTheme.placeholderColor),
          ),
        ),
        showError: true,
        showEmpty: true,
      ),
    );
  }
}
