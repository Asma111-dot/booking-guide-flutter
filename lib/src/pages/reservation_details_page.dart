import 'package:booking_guide/src/extensions/string_formatting.dart';
import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reservation/reservation_provider.dart';
import '../models/reservation.dart' as res;
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../extensions/date_formatting.dart';
import '../widgets/custom_row_widget.dart';
import '../widgets/view_widget.dart';
import 'payment_page.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: CustomAppBarClipper(
          backgroundColor: CustomTheme.primaryColor,
          height: 160.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 200.0),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    trans().reservationDetails,
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
      body: ViewWidget<res.Reservation>(
        meta: reservationState.meta,
        data: reservationState.data,
        refresh: () async => await ref
            .read(reservationProvider.notifier)
            .fetch(roomPriceId: widget.roomPriceId),
        forceShowLoaded: reservationState.data != null,
        onLoaded: (data) {
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
                              color: Colors.grey.withOpacity(0.5),
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
                            "  ${data.roomPrice?.room?.facility?.name ?? 'غير متوفر'}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: CustomTheme.primaryColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                " ${data.roomPrice?.room?.facility?.address ?? 'غير متوفر'}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                // reservation date
                CustomRowWidget(
                  icon: Icons.calendar_today,
                  label: trans().reservation_date,
                  value: data.checkInDate.toDateDateView() ,
                ),

                const SizedBox(height: 12),
                // period
                CustomRowWidget(
                  icon: Icons.playlist_add_check_rounded,
                  label: trans().period,
                  value: data.roomPrice?.period ?? 'غير متوفر',
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
                  value: data.bookingType  ,
                ),
                const SizedBox(height: 12),
                //
                CustomRowWidget(
                  icon: Icons.groups_2_outlined,
                  label: trans().adults_count,
                  value: data.adultsCount?.toString() ?? 'غير متوفر',
                ),
                const SizedBox(height: 12),
                CustomRowWidget(
                  icon: Icons.groups_2,
                  label: trans().children_count,
                  value: data.childrenCount?.toString() ?? 'غير متوفر',
                ),

                const SizedBox(height: 15),
                const Divider(color: Colors.grey),
                const SizedBox(height: 15),

                // Price data
                CustomRowWidget(
                  icon: Icons.price_check_rounded,
                  label: trans().total_price,
                  value: data.totalPrice?.toString() ?? 'غير متوفر',
                ),
                const SizedBox(height: 12),
                CustomRowWidget(
                  icon: Icons.money_off_csred,
                  label: "${trans().amount_to_be_paid} (${trans().deposit})",
                  value: data.roomPrice?.deposit?.toString() ?? 'غير متوفر',
                ),
              ],
            ),
          );
        },
        onLoading: () => const Center(child: CircularProgressIndicator()),
        onEmpty: () => Center(
          child: Text("لا توجد بيانات متاحة"),
        ),
        showError: true,
        showEmpty: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
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
            final reservation = reservationState.data;
            if (reservation != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(reservation: reservation),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
