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
import '../widgets/custom_row_widget.dart';
import '../widgets/view_widget.dart';

class ReservationDetailsPage extends ConsumerStatefulWidget {
  final int roomPriceId;

  const ReservationDetailsPage({
    super.key,
    required this.roomPriceId,
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
          .fetch(roomPriceId: widget.roomPriceId);
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
      body: ViewWidget<res.Reservation>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationProvider.notifier)
            .fetch(roomPriceId: widget.roomPriceId),
        forceShowLoaded: reservationState.data != null,
        onLoaded: (data) {
          final checkIn = data.checkInDate;
          final checkOut = data.checkOutDate;
          final daysCount = checkOut.difference(checkIn).inDays;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name & logo
                Row(
                  children: [
                    if (data.roomPrice?.room?.facility?.logo != null) ...[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1 * 255),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          image: DecorationImage(
                            image: NetworkImage(
                                data.roomPrice!.room!.facility!.logo!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "  ${data.roomPrice?.room?.facility?.name ?? trans().not_available}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CustomTheme.primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: CustomTheme.color2,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                " ${data.roomPrice?.room?.facility?.address ?? trans().not_available}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: CustomTheme.color3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                // reservation date
                CustomRowWidget(
                  icon: Icons.calendar_today,
                  label: trans().reservation_date,
                  value: data.checkInDate.toDateDateView(),
                ),
                if (checkOut.isAfter(checkIn)) ...[
                  const SizedBox(height: 12),
                  CustomRowWidget(
                    icon: Icons.date_range,
                    label: trans().number_of_days,
                    value: "$daysCount ${trans().day}",
                  ),
                  const SizedBox(height: 12),
                  CustomRowWidget(
                    icon: Icons.logout,
                    label: trans().check_out_date,
                    value: checkOut.toDateDateView(),
                  ),
                ],

                const SizedBox(height: 12),
                // period
                CustomRowWidget(
                  icon: Icons.playlist_add_check_rounded,
                  label: trans().period,
                  value: data.roomPrice?.period ?? trans().not_available,
                ),
                const SizedBox(height: 12),
                // Time
                CustomRowWidget(
                  icon: Icons.access_time,
                  label: trans().access_time,
                  value:
                      "${data.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${data.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                ),

                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),

                // Attendance data
                CustomRowWidget(
                  icon: Icons.personal_injury_outlined,
                  label: trans().attendance_type,
                  value: data.bookingType,
                ),
                const SizedBox(height: 12),
                //
                CustomRowWidget(
                  icon: Icons.groups_2_outlined,
                  label: trans().adults_count,
                  value: data.adultsCount != null
                      ? '${data.adultsCount.toString()} ${trans().person}'
                      : trans().not_available,
                ),
                const SizedBox(height: 12),
                CustomRowWidget(
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
                CustomRowWidget(
                  icon: Icons.price_check_rounded,
                  label: trans().total_price,
                  value: data.totalPrice != null
                      ? '${data.totalPrice?.toInt()} ${trans().riyalY}'
                      : trans().not_available,
                ),

                const SizedBox(height: 12),
                CustomRowWidget(
                  icon: Icons.money_off_csred,
                  label: "${trans().amount_to_be_paid} (${trans().deposit})",
                  value: data.roomPrice?.deposit != null
                      ? '${data.roomPrice!.deposit?.toInt()} ${trans().riyalY}'
                      : trans().not_available,
                ),

                const SizedBox(height: 20),
                Center(
                  child: Button(
                    width: MediaQuery.of(context).size.width - 40,
                    title: trans().payment_now,
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Colors.white,
                    ),
                    iconAfterText: true,
                    disable: false,
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        Routes.payment,
                        arguments: data.id,
                      );
                    },
                  ),
                ),
              ],
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
