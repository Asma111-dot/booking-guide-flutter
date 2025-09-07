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

class FacilityGridWidget extends ConsumerWidget {
  final Facility facility;

  const FacilityGridWidget({
    super.key,
    required this.facility,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final isFavorite = ref.watch(favoritesProvider.select(
      (state) => state.data?.any((f) => f.id == facility.id) ?? false,
    ));

    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.facilityTypeId == 1 ? hotelImage : chaletImage);

    final firstPrice = facility.price ?? 0.0;
    final finalPrice = facility.finalPrice ?? firstPrice;
    final hasDiscount = finalPrice < firstPrice;

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
        decoration: BoxDecoration(
          color: colorScheme.surface,
          // borderRadius: BorderRadius.circular(20),
          borderRadius: Corners.md15,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
              blurRadius: S.r(6),
              offset: Offset(0, S.h(3)),
            ),
          ],

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: Corners.md15,
                  child: AspectRatio(
                    aspectRatio: 3 / 2, // جرّب 4/3 أو 16/9 بحسب التصميم
                    child: CachedNetworkImage(
                      imageUrl: defaultImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ShimmerImagePlaceholder(
                              width: double.infinity, height: double.infinity),
                      errorWidget: (context, url, error) =>
                          Image.asset(appIcon, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: Insets.xs8,
                  left: Insets.xs8,
                  child: Container(
                    padding: EdgeInsets.all(S.r(1)),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.05),
                          blurRadius: S.r(4),
                          offset: Offset(0, S.h(4)),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? favoriteFullIcon : favoriteIcon,
                        color: isFavorite
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.4),
                        size: Sizes.iconM20,
                      ),
                      onPressed: () async {
                        final userId = currentUser()?.id;
                        if (userId != null) {
                          await ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(ref, userId, facility);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Insets.xs8, vertical: Insets.xxs6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: TFont.m14,
                      ),
                    ),
                    Gaps.h4,

                    // سطر السعر
                    Text(
                      finalPrice > 0
                          ? '${trans().priceStartFrom} ${finalPrice.toStringAsFixed(0)}${trans().riyalY}'
                          : trans().priceNotAvailable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hasDiscount
                            ? colorScheme.onTertiary
                            : colorScheme.tertiary,
                        fontSize: TFont.s12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // السعر قبل الخصم (يختفي إن لم يكن خصمًا)
                    if (hasDiscount)
                      Text(
                        '${firstPrice.toStringAsFixed(0)}${trans().riyalY}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: TFont.xxs10,
                          color: colorScheme.onSurface.withOpacity(0.4),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                    Gaps.h4,

                    // العنوان
                    Row(
                      children: [
                        Icon(mapIcon,
                            color: colorScheme.secondary, size: Sizes.iconS16),
                        Gaps.w4,
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: TFont.s12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(), // يدفع المحتوى للأعلى عند الحاجة
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
