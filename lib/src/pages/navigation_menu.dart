import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/general_helper.dart';
import '../storage/auth_storage.dart';
import '../utils/theme.dart';
import 'booking_page.dart';
import 'facility_types_page.dart';
import 'favorites_page.dart';
import 'map_page.dart';
import 'account_page.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({Key? key}) : super(key: key);

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
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white10),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              if (index >= 0 && index < controller.screens.length) {
                controller.selectedIndex.value = index;
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: CustomTheme.primaryColor,
            unselectedItemColor: CustomTheme.tertiaryColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: trans().facilityTypes,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_on_outlined),
                label: trans().map,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.sticky_note_2_outlined),
                label: trans().booking,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_outline_outlined),
                label: trans().favorite,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_2_outlined),
                label: trans().persons,
              ),
            ],
          ),
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
