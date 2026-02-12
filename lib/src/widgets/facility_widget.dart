import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
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

    // if (!_isWithinPriceRange(firstPrice)) {
    //   return const SizedBox();
    // }

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
        margin: EdgeInsets.symmetric(vertical: Insets.xs8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: Corners.md15,
          boxShadow: [
            BoxShadow(
              // color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
              color: Theme.of(context).shadowColor.withOpacity(0.10),
              blurRadius: S.r(6),
              offset: Offset(0, S.h(2)),
            ),
          ],
        ),
        child: Padding(
            padding: EdgeInsets.all(Insets.xs8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: Corners.md15,
                  child: CachedNetworkImage(
                    imageUrl: defaultImage,
                    width: S.w(100),
                    height: S.w(100),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerImagePlaceholder(
                        width: S.w(80), height: S.w(80)),
                    errorWidget: (context, url, error) => Image.asset(
                      appIcon,
                      width: S.w(100),
                      height: S.w(100),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: TFont.m14,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gaps.h6,
                      (finalPrice > 0)
                          ? Wrap(
                              spacing: Insets.xxs6,
                              children: [
                                Text(
                                  '${trans().priceStartFrom} ${finalPrice.toStringAsFixed(0)}${trans().riyalY}',
                                  style: TextStyle(
                                    color: hasDiscount
                                        ? colorScheme.onTertiary
                                        : colorScheme.tertiary,
                                    fontSize: TFont.s12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (hasDiscount)
                                  Text(
                                    '${firstPrice.toStringAsFixed(0)}${trans().riyalY}',
                                    style: TextStyle(
                                      color: colorScheme.onSurface
                                          .withOpacity(0.4),
                                      fontSize: TFont.xxs8,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            )
                          : Text(
                              trans().priceNotAvailable,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.4),
                                fontSize: TFont.xxs8,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                      Gaps.h4,
                      if (facility.appliedDiscounts.isNotEmpty)
                        Gaps.h6,
                      Row(
                        children: [
                          Icon(
                            mapIcon,
                            color: colorScheme.secondary,
                            size: Sizes.iconS16,
                          ),
                          Gaps.w4,
                          Expanded(
                            child: Text(
                              facility.address ?? trans().address,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontSize: TFont.xxs10,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
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
                      await ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(ref, userId, facility);
                    }
                  },
                ),
              ],
            )),
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
