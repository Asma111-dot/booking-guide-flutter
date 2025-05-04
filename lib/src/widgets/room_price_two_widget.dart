import 'package:booking_guide/src/extensions/date_formatting.dart';
import 'package:booking_guide/src/extensions/string_formatting.dart';
import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/theme.dart';

class RoomPriceWidget extends StatelessWidget {
  final RoomPrice roomPrice;
  final bool isSelected;
  final void Function()? onTap;

  const RoomPriceWidget({
    Key? key,
    required this.roomPrice,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  Color _getColor() {
    return isSelected
         ? CustomTheme.color2 : CustomTheme.color2;
        //? CustomTheme.primaryColor : Colors.grey;
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      color: isSelected ? CustomTheme.color3 : CustomTheme.primaryColor,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              _buildRow(Icons.monetization_on_outlined,
                  "${roomPrice.amount.toInt()} ${trans().riyalY}"),
              _buildRow(Icons.calendar_today, roomPrice.period),
              _buildRow(Icons.groups_2_outlined,
                  "${roomPrice.capacity} ${trans().person}"),
              _buildRow(Icons.money_off_sharp,
                  "${trans().deposit} ${roomPrice.deposit!.toInt()} ${trans().riyalY}"),
              _buildRow(Icons.access_time,
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
        Icon(icon, size: 16, color: _getColor()),
        const SizedBox(width: 8),
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
