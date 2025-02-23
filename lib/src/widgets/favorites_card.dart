import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';

class FavoriteCard extends StatelessWidget {
  final Facility facility;

  const FavoriteCard({
    Key? key,
    required this.facility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.id == facility.id ? hotelImage : chaletImage); // ✅ استخدام facilityTypeId

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          facility.facilityTypeId == 1
              ? Routes.hotelDetails
              : Routes.roomDetails,
          arguments: facility,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: defaultImage,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  defaultImage,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    facility.name,
                    style: TextStyle(
                      color: CustomTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          facility.address ?? trans().address,
                          style: const TextStyle(
                            color: CustomTheme.tertiaryColor,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
