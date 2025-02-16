import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/save_widget.dart';

class FacilityWidget extends StatelessWidget {
  final Facility facility;

  const FacilityWidget({
    Key? key,
    required this.facility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstRoom = facility.rooms.isNotEmpty ? facility.rooms.first : null;
    final firstPrice = (firstRoom?.roomPrices.isNotEmpty == true)
        ? firstRoom!.roomPrices.first.amount
        : 0.0;
    final defaultImage = facility.name == 'hotel' ? hotelImage : chaletImage;

    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: facility.logo?.isNotEmpty == true ? facility.logo! : '',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              defaultImage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          facility.name,
          style: TextStyle(
            color: CustomTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstPrice > 0
                  ? '${trans().priceStartFrom} ${firstPrice}${trans().riyalY}'
                  : '${trans().priceNotAvailable}',
              style: TextStyle(
                color: firstPrice > 0 ? Colors.amber : Colors.redAccent,
                fontSize: 12,
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
        trailing: SizedBox(
          width: 40,
          child: SaveButtonWidget(
            itemId: facility.id,
            iconColor: CustomTheme.primaryColor,
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            facility.name == 'hotel'
                ? Routes.hotelDetails
                : Routes.chaletDetails,
            arguments: facility,
          );
        },
      ),
    );
  }
}
