import 'package:booking_guide/src/extensions/string_formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../extensions/date_formatting.dart';
import '../widgets/custom_header_details_widget.dart';
import '../widgets/custom_row_details_widget.dart';
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
        onLoaded: (data) {
          final checkIn = data.checkInDate;
          final checkOut = data.checkOutDate;
          final daysCount = checkOut.difference(checkIn).inDays + 1;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            // 🟢 إضافة مساحة للزر
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeaderDetailsWidget(
                  logo: data.roomPrice?.room?.facility?.logo,
                  name: data.roomPrice?.room?.facility?.name,
                  address: data.roomPrice?.room?.facility?.address,
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                // reservation date
                CustomRowDetailsWidget(
                  icon: Icons.calendar_today,
                  label: trans().reservation_date,
                  value: data.checkInDate.toDateDateView(),
                ),
                if (checkOut.isAfter(checkIn)) ...[
                  const SizedBox(height: 12),
                  CustomRowDetailsWidget(
                    icon: Icons.date_range,
                    label: trans().number_of_days,
                    value: formatDaysAr(daysCount),
                  ),
                  const SizedBox(height: 12),
                  CustomRowDetailsWidget(
                    icon: Icons.logout,
                    label: trans().check_out_date,
                    value: checkOut.toDateDateView(),
                  ),
                ],

                const SizedBox(height: 12),
                // period
                CustomRowDetailsWidget(
                  icon: Icons.playlist_add_check_rounded,
                  label: trans().period,
                  value: data.roomPrice?.period ?? trans().not_available,
                ),
                const SizedBox(height: 12),
                // Time
                CustomRowDetailsWidget(
                  icon: Icons.access_time,
                  label: trans().access_time,
                  value:
                      "${data.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${data.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                ),

                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),

                // Attendance data
                CustomRowDetailsWidget(
                  icon: Icons.personal_injury_outlined,
                  label: trans().attendance_type,
                  value: data.bookingType,
                ),
                const SizedBox(height: 12),
                //
                CustomRowDetailsWidget(
                  icon: Icons.groups_2_outlined,
                  label: trans().adults_count,
                  value: data.adultsCount != null
                      ? '${data.adultsCount.toString()} ${trans().person}'
                      : trans().not_available,
                ),
                const SizedBox(height: 12),
                CustomRowDetailsWidget(
                  icon: Icons.groups_2,
                  label: trans().children_count,
                  value: data.childrenCount != null
                      ? '${data.childrenCount.toString()} ${trans().person}'
                      : trans().not_available,
                ),

                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),

                // Price data
                CustomRowDetailsWidget(
                  icon: Icons.price_check_rounded,
                  label: trans().total_price,
                  value: data.totalPrice != null
                      ? '${data.totalPrice?.toInt()} ${trans().riyalY}'
                      : trans().not_available,
                ),

                const SizedBox(height: 12),
                CustomRowDetailsWidget(
                  icon: Icons.money_off_csred,
                  label: "${trans().amount_to_be_paid} (${trans().deposit})",
                  value: data.roomPrice?.deposit != null
                      ? '${data.roomPrice!.deposit?.toInt()} ${trans().riyalY}'
                      : trans().not_available,
                ),
              ],
            ),
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(child: Text(trans().no_data)),
        showError: true,
        showEmpty: true,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Button(
          width: double.infinity,
          title: trans().payment_now,
          icon: const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
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
      ),
    );
  }
}
