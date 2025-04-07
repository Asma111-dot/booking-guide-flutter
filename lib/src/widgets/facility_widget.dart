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

  const FacilityWidget({
    Key? key,
    required this.facility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider.select(
          (state) => state.data?.any((f) => f.id == facility.id) ?? false,
    ));

    final firstRoom = facility.rooms.isNotEmpty ? facility.rooms.first : null;
    final firstPrice = (firstRoom?.roomPrices.isNotEmpty == true)
        ? firstRoom!.roomPrices.first.amount
        : 0.0;

    return GestureDetector(
      onTap: () {
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
                  imageUrl: facility.logo?.isNotEmpty == true
                      ? facility.logo!
                      : logoCoverImage,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      firstPrice > 0
                          ? '${trans().priceStartFrom} $firstPrice${trans().riyalY}'
                          : trans().priceNotAvailable,
                      style: TextStyle(
                        color: firstPrice > 0 ? Colors.amber : Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            facility.address ?? trans().address,
                            style: TextStyle(
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
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
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
}