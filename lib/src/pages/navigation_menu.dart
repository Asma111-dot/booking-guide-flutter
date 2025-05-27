import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/general_helper.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import 'booking_page.dart';
import 'facility_types_page.dart';
import 'favorites_page.dart';
import 'map_page.dart';
import 'account_page.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = currentUser()?.id ?? 0;
    final facilityId = 1;

    final controller = Get.put(NavigationController(
      userId: userId,
      facilityId: facilityId,
    ));

    return Obx(() => Scaffold(
          body: controller.screens[controller.selectedIndex.value],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(controller.screens.length, (index) {
            final isSelected = controller.selectedIndex.value == index;

            final iconData = [
              homeIcon,
              mapIcon,
              bookingIcon,
              favoriteIcon,
              personIcon,
            ][index];

            final label = [
              trans().facilityTypes,
              trans().map,
              trans().booking,
              trans().favorite,
              trans().persons,
            ][index];

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedIndex.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconData,
                        color: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w400 : FontWeight.w200,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
        ));
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  late final List<Widget> screens;

  NavigationController({
    required int userId,
    required int facilityId,
  }) {
    screens = [
      const FacilityTypesPage(),
      MapPage(facilityId: facilityId),
      BookingPage(userId: userId),
      FavoritesPage(userId: userId),
      AccountPage(),
    ];
  }
}
