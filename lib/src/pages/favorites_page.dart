import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../providers/facility/favorites_facility_provider.dart';
import '../utils/theme.dart';
import '../widgets/favorites_card.dart';
import '../widgets/save_widget.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  get getProvider => facilitiesProvider(FacilityTarget.maps);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilities = ref.watch(getProvider).data ?? [];
    final favorites = ref.watch(favoritesProvider);
    final selectedFacilityType = ref.watch(favoritesFacilityTypeProvider);

    final favoriteChalets = facilities
        .where((facility) => favorites.contains(facility.id) && facility.facilityTypeId == 2)
        .toList();

    final favoriteHotels = facilities
        .where((facility) => favorites.contains(facility.id) && facility.facilityTypeId == 1)
        .toList();

    final filteredFacilities = selectedFacilityType == 2
        ? favoriteChalets
        : selectedFacilityType == 1
        ? favoriteHotels
        : [...favoriteChalets, ...favoriteHotels];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().favorite,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTypeButtonWithIcon(context, ref, 'الكل', 0, Icons.border_all),
                const SizedBox(width: 10),
                _buildTypeButtonWithIcon(context, ref, 'شاليهات', 2, Icons.pool),
                const SizedBox(width: 10),
                _buildTypeButtonWithIcon(context, ref, 'فنادق', 1, Icons.hotel),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: filteredFacilities.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedFacilityType == 0) ...[
                    if (favoriteChalets.isNotEmpty) ...[
                      Text(
                        'شاليهات',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: CustomTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildGridView(favoriteChalets, favorites),
                      const SizedBox(height: 20),
                    ],
                    if (favoriteHotels.isNotEmpty) ...[
                      Text(
                        'فنادق',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: CustomTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildGridView(favoriteHotels, favorites),
                    ],
                  ] else
                    _buildGridView(filteredFacilities, favorites),
                ],
              )
                  : const Center(child: Text("لا توجد مفضلات مضافة")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButtonWithIcon(BuildContext context, WidgetRef ref, String title, int typeId, IconData icon) {
    final bool isSelected = ref.watch(favoritesFacilityTypeProvider) == typeId;

    return GestureDetector(
      onTap: () {
        ref.read(favoritesFacilityTypeProvider.notifier).setType(typeId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? CustomTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? CustomTheme.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List facilities, List<int> favorites) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7,
      ),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
        final isFav = favorites.contains(facility.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 6,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Stack(
            children: [
              FavoriteCard(facility: facility),
              Align(
                alignment: Alignment.topRight,
                child: SaveButtonWidget(
                  itemId: facility.id,
                  iconColor: isFav ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
