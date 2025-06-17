import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/facility_type_shimmer.dart';
import 'facility_page.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  const FacilityTypesPage({super.key});

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  int? selectedFacilityType;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityTypesState = ref.watch(facilityTypesProvider);
    final user = ref.watch(userProvider).data;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Image.asset(
              booking,
              width: 150,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
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
                      backgroundColor: colorScheme.surfaceVariant,
                      backgroundImage: (user?.media.isNotEmpty ?? false)
                          ? NetworkImage(user!.media.first.original_url)
                          : AssetImage(defaultAvatar) as ImageProvider,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: trans().hello_user,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.secondary,
                          ),
                          children: [
                            TextSpan(
                              text: user?.name ?? "User",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    IconButton(
                      icon: (whatsappIcon),
                      color: Colors.green,
                      onPressed: () => launchUrl(Uri.parse("https://wa.me/775421110")),
                    ),
                    IconButton(
                      icon: const Icon(notificationIcon),
                      color: colorScheme.onSurface.withOpacity(0.6),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (selectedFacilityType == null) return;
                      Navigator.pushNamed(context, Routes.filter, arguments: selectedFacilityType!);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(searchIcon, color: colorScheme.secondary),
                          const SizedBox(width: 10),
                          Text(
                            trans().search_in_facilities,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    if (selectedFacilityType == null) return;
                    Navigator.pushNamed(context, Routes.filter, arguments: selectedFacilityType!);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: CustomTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(trueIcon, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: facilityTypesState.data == null
                ? const FacilityTypeShimmer()
                : facilityTypesState.data!.isEmpty
                ? const SizedBox() // أو عرض رسالة "لا توجد أنواع"
                : SingleChildScrollView(

            // facilityTypesState.data == null || facilityTypesState.data!.isEmpty
            //     ? const Center(child: CircularProgressIndicator())
            //     : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: facilityTypesState.data!.map((facilityType) {
                  IconData icon;

                  if (facilityType.id == 1) {
                    icon = hotelIcon;
                  } else if (facilityType.id == 2) {
                    icon = poolIcon;
                  } else if (facilityType.id == 3) {
                    icon = doveIcon;
                  } else {
                    icon = defaultFacilityIcon;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: _buildTypeButtonWithIcon(
                      context,
                      facilityType.name,
                      facilityType.id,
                      icon,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: selectedFacilityType == null
                ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: 5,
              itemBuilder: (_, __) => const FacilityShimmerCard(),
            )
                : FacilityPage(facilityTypeId: selectedFacilityType!),
          ),
        ],
      ),
    );
  }
  Widget _buildTypeButtonWithIcon(
      BuildContext context,
      String title,
      int typeId,
      IconData icon,
      ) {
    final isSelected = selectedFacilityType == typeId;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => _onFacilityTypeChange(typeId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.secondary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.secondary : colorScheme.onSurface.withOpacity(0.6),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
