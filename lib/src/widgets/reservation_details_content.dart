import 'package:flutter/material.dart';

import '../extensions/string_formatting.dart';
import '../extensions/date_formatting.dart';
import '../models/reservation.dart' as res;
import 'custom_header_details_widget.dart';
import 'custom_row_details_widget.dart';
import '../helpers/general_helper.dart';

class ReservationDetailsContent extends StatelessWidget {
  final res.Reservation data;
  final EdgeInsets padding;

  const ReservationDetailsContent({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 100),
  });

  @override
  Widget build(BuildContext context) {
    final checkIn = data.checkInDate;
    final checkOut = data.checkOutDate;
    final daysCount = checkOut.difference(checkIn).inDays + 1;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderDetailsWidget(
            logo: data.roomPrice?.room?.facility?.logo,
            name: data.roomPrice?.room?.facility?.name,
            address: data.roomPrice?.room?.facility?.address,
          ),

          const SizedBox(height: 10),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 10),

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
          CustomRowDetailsWidget(
            icon: Icons.playlist_add_check_rounded,
            label: trans().period,
            value: data.roomPrice?.period ?? trans().not_available,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: Icons.access_time,
            label: trans().access_time,
            value:
            "${data.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${data.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
          ),

          const SizedBox(height: 15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 15),

          CustomRowDetailsWidget(
            icon: Icons.personal_injury_outlined,
            label: trans().attendance_type,
            value: data.bookingType,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: Icons.groups_2_outlined,
            label: trans().adults_count,
            value: data.adultsCount != null
                ? '${data.adultsCount} ${trans().person}'
                : trans().not_available,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: Icons.groups_2,
            label: trans().children_count,
            value: data.childrenCount != null
                ? '${data.childrenCount} ${trans().person}'
                : trans().not_available,
          ),

          const SizedBox(height: 15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 15),

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
            value: data.totalDeposit != null
                ? '${data.totalDeposit?.toInt()} ${trans().riyalY}'
                : trans().not_available,
          ),
        ],
      ),
    );
  }
}
