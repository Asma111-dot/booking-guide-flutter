import 'package:flutter/material.dart';

import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';

class RoomPriceWidget extends StatelessWidget {
  final RoomPrice roomPrice;
  final bool isSelected;
  final void Function()? onTap;

  const RoomPriceWidget({
    super.key,
    required this.roomPrice,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double finalPrice = roomPrice.finalPrice ?? roomPrice.price;
    final double finalDeposit = roomPrice.finalDeposit ?? (roomPrice.deposit ?? 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: S.w(MediaQuery.of(context).size.width * 0.4),
        margin: EdgeInsets.symmetric(horizontal: S.h(4)),
        padding: EdgeInsets.all(S.h(8)),
        decoration: BoxDecoration(
          gradient: isSelected ? CustomTheme.primaryGradient : null,
          color: isSelected ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(S.r(10)),
          border: Border.all(color: colorScheme.tertiary),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: S.r(4),
              offset: Offset(0, S.h(2)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRow(context, priceIcon, roomPrice.price, finalPrice, trans().riyalY),
            Gaps.h8,
            _buildRow(context, periodIcon, roomPrice.period),
            Gaps.h8,
            _buildRow(context, groupsIcon, "${roomPrice.capacity} ${trans().persons}"),
            Gaps.h8,
            _buildPriceRow(
              context,
              depositIcon,
              roomPrice.deposit?.toDouble() ?? 0,
              finalDeposit,
              trans().riyalY,
              prefix: "${trans().deposit}: ",
            ),
            // const SizedBox(height: 5),
            // _buildRow(
            //   context,
            //   accessTimeIcon,
            //   '${roomPrice.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${roomPrice.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}',
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isSelected ? Colors.white : colorScheme.onSurface;
    final iconColor = isSelected ? colorScheme.tertiary : colorScheme.secondary;

    return Row(
      children: [
        Icon(icon, size: Sizes.iconM20, color: iconColor),
        Gaps.w12,
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: TFont.s12,
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w800,
            ),
            // strutStyle: StrutStyle(height: 1.0, forceStrutHeight: true),
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context, IconData icon, double original, double discounted, String unit, {String prefix = ""}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isSelected ? Colors.white : colorScheme.onSurface;
    final iconColor = isSelected ? colorScheme.tertiary : colorScheme.secondary;

    final bool hasDiscount = discounted < original;

    return Row(
      children: [
        Icon(icon, size: Sizes.iconM20, color: iconColor),
        Gaps.w8,
        Flexible(
          child: RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              children: [
                TextSpan(
                  text: prefix,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w800,
                  ),
                ),
                if (hasDiscount) ...[
                  TextSpan(
                    text: "${original.toInt()} $unit",
                    style: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontSize: TFont.xxs10,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  TextSpan(
                    text: "  ${discounted.toInt()} $unit",
                    style: TextStyle(
                      color: isSelected ? Colors.white : colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  TextSpan(
                    text: "${original.toInt()} $unit",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
