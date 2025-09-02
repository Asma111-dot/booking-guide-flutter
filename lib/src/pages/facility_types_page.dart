import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/general_helper.dart';
import '../providers/auth/user_provider.dart';
import '../providers/connectivity_provider.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../providers/discount/discount_provider.dart';
import '../providers/notification/notification_provider.dart';
import '../providers/view_mode_provider.dart';
import '../utils/assets.dart';
import '../utils/routes.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/discount_inline_widget.dart';
import '../widgets/error_message_widget.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/facility_type_shimmer.dart';
import '../widgets/facility_type_widget.dart';
import 'facility_page.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  const FacilityTypesPage({super.key});

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage>
    with WidgetsBindingObserver {
  int? selectedFacilityType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() {
      ref.read(facilityTypesProvider.notifier).fetch();
      ref.read(userProvider.notifier).fetch();
      ref.read(discountsProvider.notifier).fetch();
      ref.read(notificationsProvider.notifier).fetch();

      ref.listen(connectivityProvider, (prev, next) {
        next.whenData((list) {
          debugPrint('🔌 Connectivity changed: $list');
        });
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // لما التطبيق يرجع للواجهة
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // جدّد الإشعارات حتى لو وصلت وأنت بالخلفية
      ref.read(notificationsProvider.notifier).fetch();
    }
  }

  void _onFacilityTypeChange(int facilityTypeId) {
    setState(() {
      selectedFacilityType = facilityTypeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityTypesState = ref.watch(facilityTypesProvider);
    final isOffline = ref.watch(isOfflineProvider);
    final userState = ref.watch(userProvider).data;
    final notificationsState = ref.watch(notificationsProvider);
    final unreadCount =
        notificationsState.data?.where((n) => n.readAt == null).length ?? 0;
    final isGrid = ref.watch(isGridProvider);

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
              Gaps.h20,
              Center(
                child: Image.asset(
                  booking,
                  width: S.w(140),
                  height: S.h(40),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.l20,
                  vertical: S.h(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: S.r(24),
                          backgroundColor: colorScheme.onPrimary,
                          backgroundImage: (userState != null &&
                                  userState.media.isNotEmpty)
                              ? NetworkImage(userState.media.first.original_url)
                              : AssetImage(defaultAvatar) as ImageProvider,
                        ),
                        Gaps.w8,
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: trans().hello_user,
                              style: TextStyle(
                                fontSize: TFont.l16,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.tertiary,
                              ),
                              children: [
                                TextSpan(
                                  text: userState?.name ?? "User",
                                  style: TextStyle(
                                    fontSize: TFont.m14,
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
                          onPressed: () =>
                              launchUrl(Uri.parse("https://wa.me/782006100")),
                        ),
                        Gaps.w8,
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(notificationIcon),
                              color: colorScheme.onSurface.withOpacity(0.6),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.notifications);
                              },
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: S.w(4),
                                top: S.h(4),
                                child: Container(
                                  padding: EdgeInsets.all(Insets.s3_4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$unreadCount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: TFont.xxs10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Insets.l20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              listAltIcon,
                              color: ref.watch(isGridProvider)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.4),
                            ),
                            onPressed: () {
                              ref.read(isGridProvider.notifier).state = true;
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              gridIcon,
                              color: !ref.watch(isGridProvider)
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.4),
                            ),
                            onPressed: () {
                              ref.read(isGridProvider.notifier).state = false;
                            },
                          ),
                        ],
                      ),
                    ),

                    // Pushes filter button to the far right
                    GestureDetector(
                      onTap: () {
                        if (selectedFacilityType == null) return;
                        Navigator.pushNamed(
                          context,
                          Routes.filter,
                          arguments: selectedFacilityType!,
                        );
                      },
                      child: Container(
                        height: S.h(50),
                        width: S.w(50),
                        decoration: BoxDecoration(
                          gradient: CustomTheme.primaryGradient,
                          borderRadius: Corners.md15,
                        ),
                        child: const Icon(searchIcon, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.h8,
              const DiscountInlineWidget(),
              Gaps.h12,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: S.w(12)),
                child: facilityTypesState.data == null
                    ? const FacilityTypeShimmer()
                    : facilityTypesState.data!.isEmpty
                        ? const SizedBox()
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  facilityTypesState.data!.map((facilityType) {
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
                                  padding: EdgeInsets.only(right: S.w(6)),
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
              Gaps.h12,
              Expanded(
                child: selectedFacilityType == null
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: Insets.m16,
                          vertical: S.h(12),
                        ),
                        itemCount: 5,
                        itemBuilder: (_, __) => const FacilityShimmerCard(),
                      )
                    : FacilityPage(facilityTypeId: selectedFacilityType!),
              ),
            ],
          ),
        ),
        if (isOffline)
          Positioned.fill(
            child: Container(
              color:
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
              child: Center(
                child: ErrorMessageWidget(
                  headerWidget: SvgPicture.asset(
                    internetIconSvg,
                    width: S.w(150),
                    height: S.h(150),
                  ),
                  textOnly: true,
                  isEmpty: true,
                  message: trans().youAreNotConnectedToTheInternet,
                  onTap: () async {
                    await ref.read(facilityTypesProvider.notifier).fetch();
                    await ref.read(userProvider.notifier).fetch();
                    await ref.read(discountsProvider.notifier).fetch();
                    await ref.read(notificationsProvider.notifier).fetch();
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
