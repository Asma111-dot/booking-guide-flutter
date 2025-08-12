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
  FacilityTarget currentTarget = FacilityTarget.hotels;

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
      default:
        currentTarget = FacilityTarget.all;
        break;
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
      Future.microtask(() {
        ref
            .read(facilitiesProvider(currentTarget).notifier)
            .fetch(facilityTypeId: widget.facilityTypeId);

        int? userId = currentUser()?.id;
        ref.read(favoritesProvider.notifier).fetchFavorites(userId: userId!);
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
                    width: 140,
                    height: 140,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    trans().no_facilities,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) =>
                      FacilityWidget(facility: data[index]),
                )
              : GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) =>
                      FacilityGridWidget(facility: data[index]),
                );
        },
        onLoading: () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (_, __) => const FacilityShimmerCard(),
        ),
      ),
    );
  }
}
