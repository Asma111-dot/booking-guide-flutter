import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';

class FacilityWidget extends ConsumerWidget {
  final Facility facility;
  final double? minPriceFilter;
  final double? maxPriceFilter;

  const FacilityWidget({
    super.key,
    required this.facility,
    this.minPriceFilter,
    this.maxPriceFilter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider.select(
          (state) => state.data?.any((f) => f.id == facility.id) ?? false,
    ));

    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.facilityTypeId == 1 ? hotelImage : chaletImage);

    final firstPrice = facility.price ?? 0.0;

    if (!_isWithinPriceRange(firstPrice)) {
      return const SizedBox();
    }

    return GestureDetector(
        onTap: () {
          if (facility.firstRoomId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('لا توجد غرف متوفرة لهذه المنشأة')),
            );
            return;
          }

          Navigator.pushNamed(
            context,
            Routes.roomDetails,
            arguments: facility,
          );
        },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: defaultImage,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    logoCoverImage,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: TextStyle(
                        color: CustomTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      firstPrice > 0
                          ? '${trans().priceStartFrom} ${firstPrice.toStringAsFixed(0)}${trans().riyalY}'
                          : trans().priceNotAvailable,
                      style: TextStyle(
                        color: firstPrice > 0 ? CustomTheme.color4 : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: CustomTheme.color3, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            style: TextStyle(
                              color: CustomTheme.color1,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? CustomTheme.color1 : Colors.grey,
                ),
                onPressed: () async {
                  final userId = currentUser()?.id;
                  if (userId != null) {
                    await ref.read(favoritesProvider.notifier)
                        .toggleFavorite(ref, userId, facility);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isWithinPriceRange(double price) {
    if (minPriceFilter == null && maxPriceFilter == null) {
      return true;
    }
    final min = minPriceFilter ?? 0;
    final max = maxPriceFilter ?? double.infinity;
    return price >= min && price <= max;
  }
}
