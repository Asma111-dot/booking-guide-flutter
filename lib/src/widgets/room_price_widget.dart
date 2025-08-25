import 'package:flutter/material.dart';

import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/amenity_icon_helper.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'room_price_media_carousel.dart';

class RoomPriceWidget extends StatelessWidget {
  final RoomPrice price;

  const RoomPriceWidget({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool hasDetails = (price.title?.trim().isNotEmpty ?? false) ||
        (price.description?.trim().isNotEmpty ?? false) ||
        (price.size != null && price.size! > 0) ||
        price.media.isNotEmpty;

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
                    fontFamily: 'Roboto',
                    color: colorScheme.onSurface.withOpacity(0.4),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "${finalPrice.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ] else ...[
                Text(
                  "${price.price.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),

          /// 📍 Period details (title / description / size / media /amenities)
          if (hasDetails) ...[
            const SizedBox(height: 6),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Icon(verifiedIcon, color: colorScheme.secondary, size: 18),
                  Text(
                    trans().package_features_detailed,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                // العنوان
                if (price.title?.trim().isNotEmpty ?? false) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.title, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          price.title!.trim(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],

                // الوصف
                if (price.description?.trim().isNotEmpty ?? false) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          price.description!.trim(),
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.4,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // الحجم + السعة (كل واحد في سطر)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (price.size != null && price.size! > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 6),
                              Text(
                                '${trans().size} : ${price.size} ${trans().meter2}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (price.capacity > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6),
                            Text(
                              '${trans().capacity}: ${price.capacity} ${trans().person}',
                              style: TextStyle(
                                fontSize:18,
                                fontFamily: 'Roboto',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),
                      if (price.deposit! > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6),
                            Text(
                              '${trans().deposit}: ${price.deposit} ${trans().riyalY}',
                              style: TextStyle(
                                fontSize:18,
                                fontFamily: 'Roboto',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                // amenities
                if (price.amenities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      ('${trans().amenities} :'),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.color3,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: price.amenities.map((a) {
                        final icon = AmenityIconHelper.getAmenityIcon(a.name);
                        return Tooltip(
                          message: (a.desc).trim().isEmpty ? a.name : a.desc,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: CustomTheme.color3.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon, size: 16, color: CustomTheme.color3),
                                const SizedBox(width: 6),
                                Text(
                                  a.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // معرض الوسائط (صور + فيديو)
                if (price.media.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        RoomPriceMediaCarousel(media: price.media, height: 150),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ],

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
                String type = discount['type'] == 'percentage'
                    ? 'نسبة مئوية'
                    : 'مبلغ ثابت';
                String value = discount['value'].toString();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_right,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
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
