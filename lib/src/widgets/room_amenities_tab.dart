import 'package:flutter/material.dart';
import '../models/room.dart' as r;
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans().available_spaces,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomTheme.color2,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 12,
              runSpacing: 5,
              children: room.availableSpaces.map((space) {
                final type = space['type'] ?? '';
                final count = int.tryParse(space['count'].toString()) ?? 1;
                final icon = AmenityIconHelper.getAmenityIcon(type);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        count > 1 ? '$count $type' : type,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(thickness: 2,),
            const SizedBox(height: 12),
            Text(
              trans().amenities_and_facilities,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CustomTheme.color2,
              ),
            ),
            const SizedBox(height: 8),
            room.amenities.isNotEmpty
                ? Wrap(
              spacing: 12,
              runSpacing: 12,
              children: room.amenities.map((a) {
                final icon = AmenityIconHelper.getAmenityIcon(a.name);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: CustomTheme.primaryColor,
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
                fontSize: 16,
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
