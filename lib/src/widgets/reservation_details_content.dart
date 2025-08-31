import 'package:flutter/material.dart';

import '../extensions/string_formatting.dart';
import '../extensions/date_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/reservation.dart' as res;
import '../enums/reservation_status.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import 'custom_header_details_widget.dart';
import 'custom_row_details_widget.dart';

class ReservationDetailsContent extends StatelessWidget {
  final res.Reservation data;
  final EdgeInsets padding;

  const ReservationDetailsContent({
    super.key,
    required this.data,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 0),
  });

  @override
  Widget build(BuildContext context) {
    final checkIn = data.checkInDate;
    final checkOut = data.checkOutDate;
    final daysCount = checkOut.difference(checkIn).inDays + 1;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(Insets.m16, Insets.m16, Insets.m16, S.h(100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomHeaderDetailsWidget(
            logo: data.roomPrice?.room?.facility?.logo,
            name: data.roomPrice?.room?.facility?.name,
            address: data.roomPrice?.room?.facility?.address,
          ),

          S.gapH(10),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          S.gapH(10),

          CustomRowDetailsWidget(
            icon: periodIcon,
            label: trans().reservation_date,
            value: data.checkInDate.toDateDateView(),
          ),

          if (checkOut.isAfter(checkIn)) ...[
            Gaps.h12,
            CustomRowDetailsWidget(
              icon: rangeDataIcon,
              label: trans().number_of_days,
              value: formatDaysAr(daysCount),
            ),
            Gaps.h12,
            CustomRowDetailsWidget(
              icon: logoutIcon,
              label: trans().check_out_date,
              value: checkOut.toDateDateView(),
            ),
          ],

          Gaps.h12,
          CustomRowDetailsWidget(
            icon: playListIcon,
            label: trans().package,
            value: data.roomPrice?.period ?? trans().not_available,
          ),

          Gaps.h12,
          CustomRowDetailsWidget(
            icon: accessTimeIcon,
            label: trans().access_time,
            value:
            "${data.roomPrice?.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - "
                "${data.roomPrice?.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
          ),

          S.gapH(15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          S.gapH(15),

          CustomRowDetailsWidget(
            icon: personalIcon,
            label: trans().attendance_type,
            value: data.bookingType,
          ),

          // const SizedBox(height: 12),
          Gaps.h12,
          CustomRowDetailsWidget(
            icon: groupsIcon,
            label: trans().adults_count,
            value: data.adultsCount != null
                ? '${data.adultsCount} ${trans().person}'
                : trans().not_available,
          ),

          Gaps.h12,
          CustomRowDetailsWidget(
            icon: groups2Icon,
            label: trans().children_count,
            value: data.childrenCount != null
                ? '${data.childrenCount} ${trans().person}'
                : trans().not_available,
          ),

          S.gapH(15),
          Divider(color: colorScheme.outline.withOpacity(0.5)),
          S.gapH(15),

          CustomRowDetailsWidget(
            icon: priceCheckIcon,
            label: trans().total_price,
            value: data.totalPrice != null
                ? '${data.totalPrice?.toInt()} ${trans().riyalY}'
                : trans().not_available,
          ),

          Gaps.h12,

          if (parseStatus(data.status) == ReservationStatus.confirmed) ...[
            CustomRowDetailsWidget(
              icon: priceIcon,
              label: trans().paid_amount,
              value: data.totalDeposit != null
                  ? '${data.totalDeposit?.toInt()} ${trans().riyalY}'
                  : trans().not_available,
            ),
            Gaps.h12,
            CustomRowDetailsWidget(
              icon: priceCheckIcon,
              label: trans().remaining_amount,
              value: (data.totalPrice != null && data.totalDeposit != null)
                  ? '${((data.totalPrice ?? 0) - (data.totalDeposit ?? 0)).toInt()} ${trans().riyalY}'
                  : trans().not_available,
            ),
          ] else ...[
            CustomRowDetailsWidget(
              icon: depositIcon,
              label: "${trans().amount_to_be_paid} (${trans().deposit})",
              value: data.totalDeposit != null
                  ? '${data.totalDeposit?.toInt()} ${trans().riyalY}'
                  : trans().not_available,
            ),
          ],
        ],
      ),
    );
  }
}
