import 'package:flutter/material.dart';
import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/assets.dart';

class RoomPriceWidget extends StatelessWidget {
  final RoomPrice price;

  const RoomPriceWidget({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    double finalPrice = price.finalPrice ?? price.price;
    bool hasDiscount = (price.discount ?? 0) > 0;
    bool hasAppliedDiscounts = price.appliedDiscounts.isNotEmpty;

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
          /// 📍 Period + Time
          Row(
            children: [
              Icon(
                periodIcon,
                color: colorScheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${price.period} | ${price.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${price.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 📍 Price display
          Row(
            children: [
              Icon(
                priceIcon,
                color: colorScheme.secondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              if (hasDiscount) ...[
                Text(
                  "${price.price.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withOpacity(0.4),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${finalPrice.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ] else ...[
                Text(
                  "${price.price.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),

          /// 📍 Discounts details with ExpansionTile
          if (hasAppliedDiscounts) ...[
            const SizedBox(height: 6),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  const Icon(Icons.local_offer, color: Colors.green, size: 16),
                  Text(
                    trans().show_discount_details,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              children: price.appliedDiscounts.map((discount) {
                String type = discount['type'] == 'percentage' ? 'نسبة مئوية' : 'مبلغ ثابت' ;
                String value = discount['value'].toString();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_right, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child:
                        Text(
                          "${discount['name']} ($type: $value)",
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
