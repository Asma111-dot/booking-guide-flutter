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
            _buildRow(context, priceIcon, "${roomPrice.price.toInt()} ${trans().riyalY}"),
            const SizedBox(height: 5),
            _buildRow(context, periodIcon, roomPrice.period),
            const SizedBox(height: 5),
            _buildRow(context, groupsIcon, "${roomPrice.capacity} ${trans().person}"),
            const SizedBox(height: 5),
            _buildRow(
              context,
              depositIcon,
              "${trans().deposit}: ${roomPrice.deposit?.toInt() ?? 0} ${trans().riyalY}",
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
}
