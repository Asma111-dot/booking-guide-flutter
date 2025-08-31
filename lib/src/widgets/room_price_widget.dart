import 'package:flutter/material.dart';

import '../extensions/date_formatting.dart';
import '../extensions/string_formatting.dart';
import '../helpers/general_helper.dart';
import '../models/room_price.dart';
import '../utils/amenity_icon_helper.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
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
      margin: EdgeInsets.symmetric(vertical: Insets.xs8),
      padding: EdgeInsets.all(Insets.m16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(S.r(12)),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: S.r(12),
            offset: Offset(0, S.h(5)),
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
                size: Sizes.iconM20,
              ),
              Gaps.w8,
              Expanded(
                child: Text(
                  "${price.period} | ${price.timeFrom?.fromTimeToDateTime()?.toTimeView() ?? '--:--'} - ${price.timeTo?.fromTimeToDateTime()?.toTimeView() ?? '--:--'}",
                  style: TextStyle(
                    fontSize: TFont.m14,
                    color: colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          Gaps.h8,

          /// 📍 Price display
          Row(
            children: [
              Icon(
                priceIcon,
                color: colorScheme.secondary,
                size: Sizes.iconS18,
              ),
              Gaps.w8,
              if (hasDiscount) ...[
                Text(
                  "${price.price.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: TFont.m14,
                    fontFamily: 'Roboto',
                    color: colorScheme.onSurface.withOpacity(0.4),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Gaps.w4,
                Text(
                  "${finalPrice.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: TFont.m14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ] else ...[
                Text(
                  "${price.price.toInt()} ${trans().riyalY}",
                  style: TextStyle(
                    fontSize: TFont.m14,
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
            Gaps.h6,
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: S.r(8),
                children: [
                  Icon(verifiedIcon,
                      color: colorScheme.secondary, size: Sizes.iconM20),
                  Text(
                    trans().package_features_detailed,
                    style: TextStyle(
                      fontSize: TFont.m14,
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
                      Icon(titleIcon, size: Sizes.iconS16),
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          price.title!.trim(),
                          style: TextStyle(
                            fontSize: TFont.m14,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.w8,
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
                            fontSize: TFont.m14,
                            height: 1.4,
                            color: colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.h12
                ],

                // الحجم + السعة (كل واحد في سطر)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (price.size != null && price.size! > 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: S.h(6)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gaps.w4,
                              Text(
                                '${trans().size} : ${price.size} ${trans().meter2}',
                                style: TextStyle(
                                  fontSize: TFont.l16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Gaps.h8,
                      if (price.capacity > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gaps.w4,
                            Text(
                              '${trans().capacity}: ${price.capacity} ${trans().person}',
                              style: TextStyle(
                                fontSize: TFont.l16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      Gaps.h8,
                      if (price.deposit! > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gaps.w4,
                            Text(
                              '${trans().deposit}: ${price.deposit} ${trans().riyalY}',
                              style: TextStyle(
                                fontSize: TFont.l16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      Gaps.h12
                    ],
                  ),
                ),

                // amenities
                if (price.amenities.isNotEmpty) ...[
                  Gaps.h12,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      ('${trans().amenities} :'),
                      style: TextStyle(
                        fontSize: TFont.l16,
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
                      spacing: S.r(8),
                      runSpacing: S.r(8),
                      children: price.amenities.map((a) {
                        final icon = AmenityIconHelper.getAmenityIcon(a.name);
                        return Tooltip(
                          message: (a.desc).trim().isEmpty ? a.name : a.desc,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Insets.s12,
                              vertical: S.h(8),
                            ),
                            decoration: BoxDecoration(
                              color: CustomTheme.color3.withOpacity(0.03),
                              borderRadius: Corners.md15,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon,
                                    size: Sizes.iconS16,
                                    color: CustomTheme.color3),
                                Gaps.w4,
                                Text(
                                  a.name,
                                  style: TextStyle(
                                    fontSize: TFont.m14,
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
                Gaps.h15,
                // معرض الوسائط (صور + فيديو)
                if (price.media.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: Corners.md15,
                    child: RoomPriceMediaCarousel(
                      media: price.media,
                      height: S.h(150),
                    ),
                  ),
                  Gaps.h8,
                ],
                Gaps.h8
              ],
            ),
          ],

          /// 📍 Discounts details with ExpansionTile
          if (hasAppliedDiscounts) ...[
            Gaps.h6,
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: S.w(6),
                children: [
                  Icon(Icons.local_offer, color: Colors.green, size: Sizes.iconS16),
                  Text(
                    trans().show_discount_details,
                    style: TextStyle(
                      fontSize: TFont.m14,
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
                  padding: EdgeInsets.symmetric(vertical: S.h(4)),
                  child: Row(
                    children: [
                      Gaps.w4,
                      Icon(Icons.arrow_right, size: Sizes.iconS16, color: Colors.grey),
                      Gaps.w4,
                      Expanded(
                        child: Text(
                          "${discount['name']} ($type: $value)",
                          style: TextStyle(
                            fontSize: TFont.s12,
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
