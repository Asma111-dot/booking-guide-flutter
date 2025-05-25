import 'package:flutter/material.dart';
import '../helpers/general_helper.dart';

class RoomPriceWidget extends StatelessWidget {
  final dynamic price;

  const RoomPriceWidget({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // period
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: colorScheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                price.period,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // price
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                color: colorScheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "${price.price?.toInt() ?? 0} ${trans().riyalY}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // capacity
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.groups_2_outlined,
          //       color: CustomTheme.primaryColor,
          //       size: 16,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       "${price.capacity} ${trans().person}",
          //       style: const TextStyle(
          //         fontSize: 16,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 8),
          // deposit
          // Row(
          //   children: [
          //     const Icon(
          //       Icons.money_off_sharp,
          //       color: CustomTheme.primaryColor,
          //       size: 16,
          //     ),
          //     const SizedBox(width: 8),
          //     Text(
          //       "${trans().deposit} ${price.deposit} ${trans().riyalY}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 8),
          // time
          // Row(
          //   children: [
          //     Icon(
          //       Icons.access_time,
          //       size: 16,
          //       color: CustomTheme.primaryColor,
          //     ),
          //     const SizedBox(width: 4),
          //     Text(
          //       '${price.timeFrom ?? '--:--'} - ${price.timeTo ?? '--:--'}',
          //       style: const TextStyle(
          //         fontSize: 14,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
