import 'package:flutter/material.dart';
import '../models/room.dart' as r;
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../helpers/general_helper.dart';
import '../utils/amenity_icon_helper.dart';

class RoomAmenitiesTab extends StatelessWidget {
  final r.Room room;
  const RoomAmenitiesTab({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: S.h(15),
        horizontal: S.w(4),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans().available_spaces,
              style: TextStyle(
                fontSize: TFont.m14,
                fontWeight: FontWeight.bold,
                color: CustomTheme.color2,
              ),
            ),
            Gaps.h8,
            Wrap(
              spacing: 12,
              runSpacing: 5,
              children: room.availableSpaces.map((space) {
                final type = space['type'] ?? '';
                final count = int.tryParse(space['count'].toString()) ?? 1;
                final icon = AmenityIconHelper.getAmenityIcon(type);

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: S.w(15),
                    vertical: S.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: CustomTheme.color3.withOpacity(0.03),
                    borderRadius: Corners.sm8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: Sizes.iconM20, color: CustomTheme.color3),
                      Gaps.w8,
                      Text(
                        count > 1 ? '$count $type' : type,
                        style:  TextStyle(
                          fontSize: TFont.s12,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Gaps.h12,
            const Divider(thickness: 1,),
            Gaps.h12,
            Text(
              trans().amenities_and_facilities,
              style:  TextStyle(
                fontSize: TFont.m14,
                fontWeight: FontWeight.bold,
                color: CustomTheme.color2,
              ),
            ),
            Gaps.h8,
            room.amenities.isNotEmpty
                ? Wrap(
              spacing: 12,
              runSpacing: 12,
              children: room.amenities.map((a) {
                final icon = AmenityIconHelper.getAmenityIcon(a.name);
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: S.w(15),
                    vertical: S.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: CustomTheme.color3.withOpacity(0.03),
                    borderRadius: Corners.sm8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: Sizes.iconM20, color: CustomTheme.color3),
                      Gaps.w8,
                      Text(
                        a.name,
                        style:  TextStyle(
                          fontSize: TFont.s12,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
                : Text(
              "${trans().amenity}: ${trans().noAmenities}",
              style: TextStyle(
                fontSize: TFont.m14,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
