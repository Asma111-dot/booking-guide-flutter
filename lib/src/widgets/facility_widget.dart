import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import 'shimmer_image_placeholder.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isFavorite = ref.watch(favoritesProvider.select(
          (state) => state.data?.any((f) => f.id == facility.id) ?? false,
    ));

    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.facilityTypeId == 1 ? hotelImage : chaletImage);

    final firstPrice = facility.price ?? 0.0;
    final finalPrice = facility.finalPrice ?? firstPrice;
    final hasDiscount = finalPrice < firstPrice;

    if (!_isWithinPriceRange(firstPrice)) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        if (facility.firstRoomId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(trans().no_rooms_available)),
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
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
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
                  placeholder: (context, url) => const ShimmerImagePlaceholder(width: 80, height: 80),
                  errorWidget: (context, url, error) => Image.asset(
                    appIcon,
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
                        color: colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                      (finalPrice > 0)
                        ? Row(
                      children: [
                        Text(
                          '${trans().priceStartFrom} ${finalPrice.toStringAsFixed(0)}${trans().riyalY}',
                          style: TextStyle(
                            color: hasDiscount ? colorScheme.onTertiary : colorScheme.tertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '${firstPrice.toStringAsFixed(0)}${trans().riyalY}',
                            style: TextStyle(
                              color: colorScheme.onSurface.withOpacity(0.4),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    )
                        : Text(
                      trans().priceNotAvailable,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (facility.appliedDiscounts.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: facility.appliedDiscounts.map((discount) {
                          return Text(
                            '- ${discount.name} (${discount.type == "percentage" ? "%" : ""}${discount.value})',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          mapIcon,
                          color: colorScheme.secondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? favoriteFullIcon : favoriteIcon,
                  color: isFavorite
                      ? colorScheme.primary
                      : colorScheme.onSurface.withOpacity(0.4),
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
