import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'facility_page.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  const FacilityTypesPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  int? selectedFacilityType;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilityTypesProvider.notifier).fetch();
      ref.read(userProvider.notifier).fetch();
    });
  }

  void _onFacilityTypeChange(int facilityTypeId) {
    setState(() {
      selectedFacilityType = facilityTypeId;

      int? userId = currentUser()?.id;
      ref.read(favoritesProvider.notifier).fetchFavorites(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityTypesState = ref.watch(facilityTypesProvider);
    final user = ref.watch(userProvider).data;

    if (facilityTypesState.data != null &&
        facilityTypesState.data!.isNotEmpty &&
        selectedFacilityType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedFacilityType = facilityTypesState.data!.first.id;
        });
      });
    }
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     trans().facilityTypes,
      //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      //           color: CustomTheme.primaryColor,
      //           fontWeight: FontWeight.bold,
      //         ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: user?.avatar != null
                          ? NetworkImage(user!.avatar!)
                          : AssetImage(defaultAvatar) as ImageProvider,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: trans().hello_user,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: user?.name ?? "User",
                              style: const TextStyle(
                                color: CustomTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                      color: Colors.green,
                      onPressed: () {
                        launchUrl(Uri.parse("https://wa.me/775421110"));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.notification_important_outlined),
                      color: Colors.grey,
                      onPressed: () {
                        // TODO: افتح صفحة الإشعارات
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 4),
                // Text(
                // 'موقعك الحالي - ${user?.address ?? "غير محدد"}',
                // style: const TextStyle(
                // fontSize: 14,
                // color: Colors.grey,
                // ),
                // textDirection: TextDirection.rtl,
                // ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: trans().search,
                        prefixIcon: Icon(
                          Icons.search,
                          color: CustomTheme.primaryColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: CustomTheme.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Text(
          //     trans().facilityTypes,
          //     style: TextStyle(
          //       fontSize: 25,
          //       fontWeight: FontWeight.bold,
          //       color: CustomTheme.primaryColor,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: facilityTypesState.data == null ||
                    facilityTypesState.data!.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: facilityTypesState.data!.map((facilityType) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildTypeButtonWithIcon(
                          context,
                          facilityType.name,
                          facilityType.id,
                          facilityType.id == 1 ? Icons.hotel : Icons.pool,
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 0),
          // Expanded(
          //   child: selectedFacilityType == null
          //       ? const Center(child: Text("اختر نوع المنشأة"))
          //       : FacilityPage(facilityTypeId: selectedFacilityType ?? 0),
          //   //     : FacilityPage(
          //   //   facilityTypeId: selectedFacilityType ?? 0,
          //   //   searchQuery: searchQuery,
          //   // ),
          //
          // ),

          const SizedBox(height: 10),

// صفحة المنشآت
          Expanded(
            child: selectedFacilityType == null
                ? Center(
                    child: Text(
                      trans().selectFacilityType,
                    ),
                  )
                : FacilityPage(
                    facilityTypeId: selectedFacilityType ?? 0,
                    searchQuery: searchQuery,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButtonWithIcon(
      BuildContext context, String title, int typeId, IconData icon) {
    final bool isSelected = selectedFacilityType == typeId;
    return GestureDetector(
      onTap: () => _onFacilityTypeChange(typeId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 10),
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
}
