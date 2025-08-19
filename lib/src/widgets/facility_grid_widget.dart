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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة بنسبة ثابتة بدل height ثابت
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio:  3/2 , // جرّب 4/3 أو 16/9 بحسب التصميم
                    child: CachedNetworkImage(
                      imageUrl: defaultImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const ShimmerImagePlaceholder(width: double.infinity, height: double.infinity),
                      errorWidget: (context, url, error) =>
                          Image.asset(appIcon, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withOpacity(0.4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? favoriteFullIcon : favoriteIcon,
                        color: isFavorite
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.4),
                        size: 22,
                      ),
                      onPressed: () async {
                        final userId = currentUser()?.id;
                        if (userId != null) {
                          await ref.read(favoritesProvider.notifier)
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

            // اجعل منطقة النص مرنة
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // سطر السعر
                    Text(
                      finalPrice > 0
                          ? '${trans().priceStartFrom} ${finalPrice.toStringAsFixed(0)}${trans().riyalY}'
                          : trans().priceNotAvailable,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hasDiscount ? colorScheme.onTertiary : colorScheme.tertiary,
                        fontSize: 12,
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
                          fontSize: 10,
                          color: colorScheme.onSurface.withOpacity(0.4),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                    const SizedBox(height: 4),

                    // العنوان
                    Row(
                      children: [
                        Icon(Icons.location_on, color: colorScheme.secondary, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // لو احتجت مساحة لتفادي الضغط:
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
