import 'package:booking_guide/src/extensions/date_formatting.dart';
import 'package:booking_guide/src/extensions/string_formatting.dart';
import 'package:booking_guide/src/pages/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/payment.dart' as p;
import '../providers/payment/payment_provider.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/custom_row_widget.dart';
import '../widgets/shere_button_widget.dart';
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
                  Row(
                    children: [
                      if (reservation?.roomPrice?.room?.facility?.logo !=
                          null) ...[
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
                              image: NetworkImage(reservation!
                                  .roomPrice!.room!.facility!.logo!),
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
                              "  ${reservation?.roomPrice?.room?.facility?.name ?? trans().not_available}",
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
                                  " ${reservation?.roomPrice?.room?.facility?.address ?? trans().not_available}",
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
                  Text(
                    trans().payment_details,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: CustomTheme.primaryColor),
                  ),
                  const SizedBox(height: 15),
                  CustomRowWidget(
                    icon: Icons.price_change,
                    label: trans().paid_amount,
                    value: "${data.amount.toInt()} ${trans().riyalY}",
                  ),
                  const SizedBox(height: 8),
                  CustomRowWidget(
                    icon: Icons.date_range,
                    label: trans().payment_date,
                    value: "${data.date.toDateView()}",
                  ),
                  const SizedBox(height: 8),
                  CustomRowWidget(
                    icon: Icons.payment,
                    label: trans().status,
                    value: (data.status),
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    trans().reservationDetails,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: CustomTheme.primaryColor),
                  ),
                  const SizedBox(height: 12),
                  if (reservation != null) ...[
                    // CustomRowWidget(
                    //   icon: Icons.add_business_rounded,
                    //   label: trans().chalet_name,
                    //   value: reservation.roomPrice?.room?.name ??
                    //       trans().not_available,
                    // ),
                    // CustomRowWidget(
                    //   icon: Icons.room,
                    //   label: trans().address,
                    //   value: reservation.roomPrice?.room?.facility?.address ??
                    //       trans().not_available,
                    // ),
                    CustomRowWidget(
                      icon: Icons.calendar_today,
                      label: trans().check_in_date,
                      value: reservation.checkInDate.toDateDateView(),
                    ),
                    const SizedBox(height: 8),
                    CustomRowWidget(
                      icon: Icons.calendar_today_outlined,
                      label: trans().check_out_date,
                      value: reservation.checkOutDate.toDateDateView(),
                    ),
                    const SizedBox(height: 8),
                    CustomRowWidget(
                      icon: Icons.access_time,
                      label: trans().access_time,
                      value:
                          "${reservation.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${reservation.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                    ),
                    const SizedBox(height: 8),
                    CustomRowWidget(
                      icon: Icons.personal_injury_outlined,
                      label: trans().attendance_type,
                      value: "${reservation.bookingType}",
                    ),
                    const SizedBox(height: 8),
                    CustomRowWidget(
                      icon: Icons.people,
                      label: trans().adults_count,
                      value: "${reservation.adultsCount} ${trans().person}",
                    ),
                    const SizedBox(height: 8),
                    CustomRowWidget(
                      icon: Icons.child_care,
                      label: trans().children_count,
                      value: "${reservation.childrenCount} ${trans().person}",
                    ),
                    const SizedBox(height: 15),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      trans().other_details,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: CustomTheme.primaryColor),
                    ),
                    const SizedBox(height: 12),

                    CustomRowWidget(
                      icon: Icons.money,
                      label: trans().total_price,
                      value:
                          "${reservation.totalPrice?.toInt()} ${trans().riyalY}",
                    ),

                    const SizedBox(height: 8),

                    CustomRowWidget(
                      icon: Icons.paid,
                      label: trans().paid_amount,
                      value: "${data.amount.toInt()} ${trans().riyalY}",
                    ),

                    const SizedBox(height: 8),

                    CustomRowWidget(
                      icon: Icons.price_check,
                      label: trans().remaining_amount,
                      value:
                          "${(reservation.totalPrice?.toInt() ?? 0) - (data.amount.toInt())} ${trans().riyalY}",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Button(
              width: (MediaQuery.of(context).size.width - 50) / 2,
              title: trans().close_and_go_back,
              icon: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
              iconAfterText: true,
              disable: false,
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationMenu()),
                );
                // Navigator.pushNamedAndRemoveUntil(
                //   context,
                //   Routes.facilityTypes,
                //   (r) => false,
                // );
              },
            ),
            // Button(
            //   width: (MediaQuery.of(context).size.width - 50) / 2,
            //   title: trans().share,
            //   icon: const Icon(
            //     Icons.share,
            //     size: 20,
            //     color: Colors.white,
            //   ),
            //   iconAfterText: true,
            //   disable: false,
            //   onPressed: () async {
            //     // كود المشاركة (تستطيع استخدام حزمة share_plus)
            //     print("تم الضغط على زر المشاركة");
            //   },
            // ),
            ShareButton(
           //   textToShare: "جرب تطبيقنا الجديد للحجوزات! 🌟",
                textToShare: "جرب تطبيقنا الآن! 📲 https://play.google.com/store/apps/details?id=com.mybooking",
            ),
          ],
        ),
      ),
    );
  }
}
