import 'package:flutter/material.dart';

import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/assets.dart';
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
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isSelected ? CustomTheme.primaryGradient : null,
          color: isSelected ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRow(context, priceIcon, roomPrice.price, finalPrice, trans().riyalY),
            const SizedBox(height: 5),
            _buildRow(context, periodIcon, roomPrice.period),
            const SizedBox(height: 5),
            _buildRow(context, groupsIcon, "${roomPrice.capacity} ${trans().person}"),
            const SizedBox(height: 5),
            _buildPriceRow(
              context,
              depositIcon,
              roomPrice.deposit?.toDouble() ?? 0,
              finalDeposit,
              trans().riyalY,
              prefix: "${trans().deposit}: ",
            ),
            const SizedBox(height: 5),
            _buildRow(
              context,
              accessTimeIcon,
              '${roomPrice.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${roomPrice.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isSelected ? Colors.white : colorScheme.onSurface;
    final iconColor = isSelected ? Colors.white : colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w800,
            ),
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
    final iconColor = isSelected ? Colors.white : colorScheme.primary;

    final bool hasDiscount = discounted < original;

    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 10),
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
                      fontSize: 13,
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
