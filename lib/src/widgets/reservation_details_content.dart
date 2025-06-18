import 'package:flutter/material.dart';

import '../extensions/string_formatting.dart';
import '../extensions/date_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/reservation.dart' as res;
import '../utils/assets.dart';
import 'custom_header_details_widget.dart';
import 'custom_row_details_widget.dart';

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
            icon:   periodIcon,
            label: trans().reservation_date,
            value: data.checkInDate.toDateDateView(),
          ),
          if (checkOut.isAfter(checkIn)) ...[
            const SizedBox(height: 12),
            CustomRowDetailsWidget(
              icon: rangeDataIcon,
              label: trans().number_of_days,
              value: formatDaysAr(daysCount),
            ),
            const SizedBox(height: 12),
            CustomRowDetailsWidget(
              icon: logoutIcon,
              label: trans().check_out_date,
              value: checkOut.toDateDateView(),
            ),
          ],

          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: playListIcon,
            label: trans().period,
            value: data.roomPrice?.period ?? trans().not_available,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: accessTimeIcon,
            label: trans().access_time,
            value:
            "${data.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${data.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
          ),

          const SizedBox(height: 15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 15),

          CustomRowDetailsWidget(
            icon: personalIcon,
            label: trans().attendance_type,
            value: data.bookingType,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: groupsIcon,
            label: trans().adults_count,
            value: data.adultsCount != null
                ? '${data.adultsCount} ${trans().person}'
                : trans().not_available,
          ),
          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: groups2Icon,
            label: trans().children_count,
            value: data.childrenCount != null
                ? '${data.childrenCount} ${trans().person}'
                : trans().not_available,
          ),

          const SizedBox(height: 15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          const SizedBox(height: 15),

          CustomRowDetailsWidget(
            icon: priceCheckIcon,
            label: trans().total_price,
            value: data.totalPrice != null
                ? '${data.totalPrice?.toInt()} ${trans().riyalY}'
                : trans().not_available,
          ),

          const SizedBox(height: 12),
          CustomRowDetailsWidget(
            icon: depositIcon,
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
