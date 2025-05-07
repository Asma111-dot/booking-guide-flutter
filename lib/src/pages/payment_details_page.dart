import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/payment.dart' as p;
import '../providers/payment/payment_provider.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/custom_row_widget.dart';
import '../widgets/view_widget.dart';
import 'navigation_menu.dart';

class PaymentDetailsPage extends ConsumerStatefulWidget {
  final int paymentId;

  const PaymentDetailsPage({super.key, required this.paymentId});

  @override
  ConsumerState<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends ConsumerState<PaymentDetailsPage> {
  final GlobalKey _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(paymentProvider.notifier)
          .fetch(paymentId: widget.paymentId);
    });
  }

  Future<void> _shareScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
          _shareKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/payment_details.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء مشاركة الصورة"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);

    return RepaintBoundary(
      key: _shareKey,
      child: Scaffold(
        appBar: CustomAppBarClipper(
          title: trans().payment_details,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (reservation?.roomPrice?.room?.facility?.logo != null)
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(reservation!
                                  .roomPrice!.room!.facility!.logo!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reservation?.roomPrice?.room?.facility?.name ??
                                  trans().not_available,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: CustomTheme.primaryColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 16, color: CustomTheme.color2),
                                const SizedBox(width: 8),
                                Text(
                                  reservation?.roomPrice?.room?.facility
                                          ?.address ??
                                      trans().not_available,
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
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    trans().payment_details,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomRowWidget(
                      icon: Icons.price_change,
                      label: trans().paid_amount,
                      value: "${data.amount.toInt()} ${trans().riyalY}"),
                  CustomRowWidget(
                      icon: Icons.date_range,
                      label: trans().payment_date,
                      value: data.date.toDateView()),
                  CustomRowWidget(
                      icon: Icons.payment,
                      label: trans().status,
                      value: data.status),
                  const Divider(height: 30),
                  Text(
                    trans().reservationDetails,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (reservation != null) ...[
                    CustomRowWidget(
                        icon: Icons.calendar_today,
                        label: trans().check_in_date,
                        value: reservation.checkInDate.toDateDateView()),
                    CustomRowWidget(
                        icon: Icons.calendar_today_outlined,
                        label: trans().check_out_date,
                        value: reservation.checkOutDate.toDateDateView()),
                    CustomRowWidget(
                        icon: Icons.access_time,
                        label: trans().access_time,
                        value:
                            "${reservation.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${reservation.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}"),
                    CustomRowWidget(
                        icon: Icons.people,
                        label: trans().adults_count,
                        value: "${reservation.adultsCount} ${trans().person}"),
                    CustomRowWidget(
                        icon: Icons.child_care,
                        label: trans().children_count,
                        value:
                            "${reservation.childrenCount} ${trans().person}"),
                    const Divider(height: 30),
                    Text(
                      trans().other_details,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColor,
                      ),
                    ),
                    CustomRowWidget(
                        icon: Icons.money,
                        label: trans().total_price,
                        value:
                            "${reservation.totalPrice?.toInt()} ${trans().riyalY}"),
                    CustomRowWidget(
                        icon: Icons.paid,
                        label: trans().paid_amount,
                        value: "${data.amount.toInt()} ${trans().riyalY}"),
                    CustomRowWidget(
                        icon: Icons.price_check,
                        label: trans().remaining_amount,
                        value:
                            "${(reservation.totalPrice?.toInt() ?? 0) - (data.amount.toInt())} ${trans().riyalY}"),
                  ],
                ],
              ),
            );
          },
          onLoading: () => const Center(child: CircularProgressIndicator()),
          onEmpty: () => Center(child: Text(trans().no_data)),
          showError: true,
          showEmpty: true,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Button(
                  title: trans().close_and_go_back,
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: CustomTheme.whiteColor,
                  ),
                  iconAfterText: true,
                  disable: false,
                  onPressed: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => NavigationMenu()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  title: trans().share,
                  icon: const Icon(
                    Icons.share,
                    size: 20,
                    color: CustomTheme.whiteColor,
                  ),
                  iconAfterText: true,
                  disable: false,
                  onPressed: _shareScreenshot,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
