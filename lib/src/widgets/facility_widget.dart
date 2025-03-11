import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/save_widget.dart';

class FacilityWidget extends ConsumerWidget {
  final Facility facility;

  const FacilityWidget({
    Key? key,
    required this.facility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstRoom = facility.rooms.isNotEmpty ? facility.rooms.first : null;
    final firstPrice = (firstRoom?.roomPrices.isNotEmpty == true)
        ? firstRoom!.roomPrices.first.amount
        : 0.0;
    //final defaultImage = facility.name == 'hotel' ? hotelImage : chaletImage;

    final defaultImage =
    facility.facilityTypeId == 1 ? hotelImage : chaletImage;

    final favorites = ref.watch(favoritesProvider);
    final isSaved = favorites.data?.any((f) => f.id == facility.id) ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          facility.name == 'hotel' ? Routes.roomDetails : Routes.roomDetails,
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
                  imageUrl: facility.logo?.isNotEmpty == true ? facility.logo! : defaultImage,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SizedBox(
                    width: 110,
                    height: 110,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    defaultImage,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      firstPrice > 0
                          ? '${trans().priceStartFrom} ${firstPrice}${trans().riyalY}'
                          : '${trans().priceNotAvailable}',
                      style: TextStyle(
                        color: firstPrice > 0 ? Colors.amber : Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          facility.address ?? '${trans().address}',
                          style: const TextStyle(
                            color: CustomTheme.tertiaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                child: SaveButtonWidget(
                  itemId: facility.id,
                  iconColor: CustomTheme.primaryColor,
                  facilityTypeId: facility.facilityTypeId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
