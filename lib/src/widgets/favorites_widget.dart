import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';

class FavoriteWidget extends StatelessWidget {
  final Facility facility;
  final VoidCallback onRemove;

  const FavoriteWidget({
    Key? key,
    required this.facility,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.facilityTypeId == 1 ? hotelImage : chaletImage);

    final typeLabel = facility.facilityTypeId == 1 ? "فندق" : "شاليه";
    final typeIcon = facility.facilityTypeId == 1 ? Icons.hotel : Icons.pool;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.roomDetails,
          arguments: facility,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1 * 255),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: defaultImage,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 110,
                      height: 110,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      logoCoverImage,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.1 * 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(typeIcon, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          typeLabel,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomTheme.primaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            style: const TextStyle(
                              fontSize: 14,
                              color: CustomTheme.tertiaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1 * 255),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.favorite, color: Colors.red, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
