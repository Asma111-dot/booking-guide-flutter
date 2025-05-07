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

  Color _getColor() {
    return isSelected
         ? CustomTheme.color2 : CustomTheme.color2;
        //? CustomTheme.primaryColor : Colors.grey;
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      color: isSelected ? Colors.white : CustomTheme.primaryColor,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.w800,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? CustomTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CustomTheme.primaryColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1 * 255),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(priceIcon,
                  "${roomPrice.amount.toInt()} ${trans().riyalY}"),
              const SizedBox(height: 5),
              _buildRow(periodIcon, roomPrice.period),
              const SizedBox(height: 5),
              _buildRow(groupsIcon,
                  "${roomPrice.capacity} ${trans().person}"),
              const SizedBox(height: 5),
              _buildRow(depositIcon,
                  "${trans().deposit} :  ${roomPrice.deposit!.toInt()} ${trans().riyalY}"),
              const SizedBox(height: 5),
              _buildRow(accessTimeIcon,
                  '${roomPrice.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${roomPrice.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: _getColor()),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: _getTextStyle(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
