import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'facility_filter_page.dart';
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
                      backgroundImage: (user?.media.isNotEmpty ?? false)
                          ? NetworkImage(user!.media.first.original_url)
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FacilityFilterPage(
                            initialFacilityTypeId: selectedFacilityType!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                      child: Row(
                        children: [
                          Icon(Icons.search, color: CustomTheme.primaryColor),
                          const SizedBox(width: 10),
                          Text(
                            'بحث في المنشآت...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 10),
          Expanded(
            child: selectedFacilityType == null
                ? Center(child: Text(trans().selectFacilityType))
                : FacilityPage(facilityTypeId: selectedFacilityType!),
          )
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
              ? CustomTheme.primaryColor.withAlpha((0.1 * 255).toInt())
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
