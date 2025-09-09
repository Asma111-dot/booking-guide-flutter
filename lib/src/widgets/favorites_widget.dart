import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../sheetes/favorite_sheet.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
import 'shimmer_image_placeholder.dart';

class FavoriteWidget extends StatelessWidget {
  final Facility facility;
  final VoidCallback onRemove;

  const FavoriteWidget({
    super.key,
    required this.facility,
    required this.onRemove,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultImage = facility.logo?.isNotEmpty == true
        ? facility.logo!
        : (facility.facilityTypeId == 1 ? hotelImage : chaletImage);

    final typeLabel = facility.facilityTypeId == 1
        ? "فندق"
        : facility.facilityTypeId == 2
            ? "شاليه"
            : "قاعة أعراس";

    final typeIcon = facility.facilityTypeId == 1
        ? hotelIcon
        : facility.facilityTypeId == 2
            ? poolIcon
            : doveIcon;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.roomDetails,
          arguments: facility,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: S.w(5),
          vertical: S.h(5),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: S.w(12),
          vertical: S.h(10),
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: Corners.md15,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: S.r(8),
              offset: Offset(0, S.h(4)),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: Corners.sm8,
                  child: CachedNetworkImage(
                    imageUrl: defaultImage,
                    width: S.w(110),
                    height: S.h(110),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerImagePlaceholder(
                      width: S.w(80),
                      height: S.h(80),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      appIcon,
                      width: S.w(110),
                      height: S.h(110),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: S.h(6),
                  left: S.w(6),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.xs8,
                      vertical: S.h(4),
                    ),

                    // child: Row(
                    //   children: [
                    //     Icon(typeIcon,
                    //         color: Colors.white, size: Sizes.iconS16),
                    //     Gaps.w4,
                    //     Text(
                    //       typeLabel,
                    //       style: TextStyle(
                    //           color: Colors.white, fontSize: TFont.s12),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
            Gaps.w12,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: S.w(4),
                  vertical: S.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gaps.h20,
                    Row(
                      children: [
                        Icon(mapIcon,
                            color: colorScheme.secondary, size: Sizes.iconS16),
                        Gaps.w4,
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
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
              padding: EdgeInsets.symmetric(
                horizontal: S.w(8),
              ),
              child: GestureDetector(
                onTap: () {
                  showRemoveFavoriteSheet(
                    context,
                    onConfirm: onRemove,
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(Insets.xxs6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.1),
                        blurRadius: S.r(4),
                        offset: Offset(0, S.h(2)),

                      ),
                    ],
                  ),
                  child: Icon(favoriteFullIcon,
                      color: colorScheme.primary,size: Sizes.iconL24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
