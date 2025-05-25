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
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_app_bar_clipper.dart';
import '../widgets/custom_header_details_widget.dart';
import '../widgets/custom_row_details_widget.dart';
import '../widgets/view_widget.dart';

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

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حدث خطأ أثناء مشاركة الصورة"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final paymentState = ref.watch(paymentProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBarClipper(title: trans().payment_details),
      body: ViewWidget<p.Payment>(
        meta: paymentState.meta,
        data: paymentState.data,
        refresh: () async =>
        await ref.read(paymentProvider.notifier).fetch(paymentId: widget.paymentId),
        forceShowLoaded: paymentState.data != null,
        onLoaded: (data) {
          final reservation = data.reservation;
          final checkIn = reservation?.checkInDate;
          final checkOut = reservation?.checkOutDate;
          final daysCount = (checkIn != null && checkOut != null)
              ? checkOut.difference(checkIn).inDays + 1
              : 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RepaintBoundary(
              key: _shareKey,
              child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeaderDetailsWidget(
                      logo: reservation?.roomPrice?.room?.facility?.logo,
                      name: reservation?.roomPrice?.room?.facility?.name,
                      address: reservation?.roomPrice?.room?.facility?.address,
                    ),
                    const SizedBox(height: 20),
                    Divider(color: colorScheme.outline.withOpacity(0.3)),
                    const SizedBox(height: 10),
                    Text(
                      trans().payment_details,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomRowDetailsWidget(
                      icon: Icons.price_change,
                      label: trans().paid_amount,
                      value: "${reservation?.totalDeposit?.toInt()} ${trans().riyalY}",
                    ),
                    CustomRowDetailsWidget(
                      icon: Icons.date_range,
                      label: trans().payment_date,
                      value: data.date.toDateView(),
                    ),
                    Divider(height: 30, color: colorScheme.outline.withOpacity(0.3)),
                    Text(
                      trans().reservationDetails,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (reservation != null) ...[
                      CustomRowDetailsWidget(
                        icon: Icons.calendar_today,
                        label: trans().check_in_date,
                        value: reservation.checkInDate.toDateDateView(),
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.calendar_today_outlined,
                        label: trans().check_out_date,
                        value: reservation.checkOutDate.toDateDateView(),
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.date_range,
                        label: trans().number_of_days,
                        value: formatDaysAr(daysCount),
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.access_time,
                        label: trans().access_time,
                        value:
                        "${reservation.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${reservation.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.people,
                        label: trans().adults_count,
                        value: "${reservation.adultsCount} ${trans().person}",
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.child_care,
                        label: trans().children_count,
                        value: "${reservation.childrenCount} ${trans().person}",
                      ),
                      Divider(height: 30, color: colorScheme.outline.withOpacity(0.3)),
                      Text(
                        trans().other_details,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.money,
                        label: trans().total_price,
                        value: "${reservation.totalPrice?.toInt()} ${trans().riyalY}",
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.paid,
                        label: trans().paid_amount,
                        value: "${reservation.totalDeposit?.toInt()} ${trans().riyalY}",
                      ),
                      CustomRowDetailsWidget(
                        icon: Icons.price_check,
                        label: trans().remaining_amount,
                        value:
                        "${((reservation.totalPrice ?? 0) - (reservation.totalDeposit ?? 0)).toInt()} ${trans().riyalY}",
                      ),
                    ],
                  ],
                ),
              ),
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
                icon: Icon(Icons.close, size: 20, color: colorScheme.onPrimary),
                iconAfterText: true,
                disable: false,
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.navigationMenu,
                        (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Button(
                title: trans().share,
                icon: Icon(Icons.share, size: 20, color: colorScheme.onPrimary),
                iconAfterText: true,
                disable: false,
                onPressed: _shareScreenshot,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
