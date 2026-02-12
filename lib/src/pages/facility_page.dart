import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../providers/favorite/favorite_provider.dart';
import '../providers/view_mode_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../widgets/facility_grid_widget.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/facility_widget.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';
import '../utils/sizes.dart';

class FacilityPage extends ConsumerStatefulWidget {
  final int facilityTypeId;

  const FacilityPage({
    super.key,
    required this.facilityTypeId,
  });

  @override
  ConsumerState createState() => _FacilityPageState();
}

class _FacilityPageState extends ConsumerState<FacilityPage> {


  late FacilityTarget currentTarget;
  @override
  void initState() {
    super.initState();
    switch (widget.facilityTypeId) {
      case 1:
        currentTarget = FacilityTarget.hotels;
        break;
      case 2:
        currentTarget = FacilityTarget.chalets;
        break;
      case 3:
        currentTarget = FacilityTarget.halls;
        break;
      default:
        currentTarget = FacilityTarget.all;
    }


    Future.microtask(() {
      ref
          .read(facilitiesProvider(currentTarget).notifier)
          .fetch(facilityTypeId: widget.facilityTypeId);

      int? userId = currentUser()?.id;
      if (userId != null &&
          (ref.read(favoritesProvider).data?.isEmpty ?? true)) {
        ref.read(favoritesProvider.notifier).fetchFavorites(userId: userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant FacilityPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.facilityTypeId != oldWidget.facilityTypeId) {

      switch (widget.facilityTypeId) {
        case 1:
          currentTarget = FacilityTarget.hotels;
          break;
        case 2:
          currentTarget = FacilityTarget.chalets;
          break;
        case 3:
          currentTarget = FacilityTarget.halls;
          break;
        default:
          currentTarget = FacilityTarget.all;
      }

      Future.microtask(() {
        ref.read(facilitiesProvider(currentTarget).notifier).fetch(
          facilityTypeId: widget.facilityTypeId,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider(currentTarget));
    final isGrid = ref.watch(isGridProvider);

    return Scaffold(
      body: ViewWidget<List<Facility>>(
        meta: facilitiesState.meta,
        data: facilitiesState.data,
        onLoaded: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    inboxIconSvg,
                    width: S.w(140),
                    height: S.w(140),
                  ),
                  Gaps.h12,
                  Text(
                    trans().no_facilities,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: TFont.s12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }
          return isGrid
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: Insets.m16),
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      FacilityWidget(facility: data[index]),
                )
              : GridView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: Insets.m16, vertical: Insets.s12),
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: S.w(6),
                    mainAxisSpacing: S.h(6),
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) =>
                      FacilityGridWidget(facility: data[index]),
                );
        },
        onLoading: () => ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Insets.m16),
          itemCount: 5,
          itemBuilder: (_, __) => const FacilityShimmerCard(),
        ),
      ),
    );
  }
}
