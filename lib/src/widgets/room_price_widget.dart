import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../utils/theme.dart';

class RoomPriceWidget extends StatelessWidget {
  final dynamic price;

  const RoomPriceWidget({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.primaryColor.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // amount
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: CustomTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "${price.amount} ${trans().riyalY}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // period
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: CustomTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                price.period,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // capacity
          Row(
            children: [
              const Icon(
                Icons.groups_2_outlined,
                color: CustomTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "${price.capacity} ${trans().person}",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // deposit
          Row(
            children: [
              const Icon(
                Icons.money_off_sharp,
                color: CustomTheme.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "${trans().deposit} ${price.deposit} ${trans().riyalY}",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // time
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: CustomTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${price.timeFrom ?? '--:--'} - ${price.timeTo ?? '--:--'}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
