import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../providers/discount/discount_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/theme.dart';
import '../widgets/discount_inline_widget.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/facility_type_shimmer.dart';
import '../widgets/facility_type_widget.dart';
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
      ref.read(discountsProvider.notifier).fetch();
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
    final userState = ref.watch(userProvider).data;

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

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 15),
              Center(
                child: Image.asset(
                  booking,
                  width: 150,
                  height: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: colorScheme.onPrimary,
                          backgroundImage: (userState != null && userState.media.isNotEmpty)
                              ? NetworkImage(userState.media.first.original_url)
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
                                color: colorScheme.tertiary,
                              ),
                              children: [
                                TextSpan(
                                  text: userState?.name ?? "User",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: (whatsappIcon),
                          color: Colors.green,
                          onPressed: () => launchUrl(Uri.parse("https://wa.me/775421110")),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(notificationIcon),
                          color: colorScheme.onSurface.withOpacity(0.6),
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const DiscountInlineWidget(),
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
                    ? const SizedBox()
                    : SingleChildScrollView(
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
                        child: FacilityTypeWidget(
                          title: facilityType.name,
                          typeId: facilityType.id,
                          selectedFacilityType: selectedFacilityType,
                          icon: icon,
                          onTap: _onFacilityTypeChange,
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
        ),
      ],
    );
  }
}
