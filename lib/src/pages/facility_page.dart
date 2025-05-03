import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../widgets/facility_widget.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';
import '../models/response/meta.dart';

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
      ref.read(facilitiesProvider(currentTarget).notifier)
          .fetch(facilityTypeId: widget.facilityTypeId);

      int? userId = currentUser()?.id;
      if (userId != null && (ref.read(favoritesProvider).data?.isEmpty ?? true)) {
        ref.read(favoritesProvider.notifier).fetchFavorites(userId: userId);
      }
    });
  }

  @override
  void didUpdateWidget(covariant FacilityPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.facilityTypeId != oldWidget.facilityTypeId) {
      Future.microtask(() {
        ref.read(facilitiesProvider(currentTarget).notifier)
            .fetch(facilityTypeId: widget.facilityTypeId);

        int? userId = currentUser()?.id;
        ref.read(favoritesProvider.notifier).fetchFavorites(userId: userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider(currentTarget));
    final favoritesState = ref.watch(favoritesProvider);

    final favoritesLoaded = favoritesState.meta.status == Status.loaded;

    if (!favoritesLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return ViewWidget<List<Facility>>(
      meta: facilitiesState.meta,
      data: facilitiesState.data,
      onLoaded: (data) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final facility = data[index];
            return FacilityWidget(facility: facility);
          },
        );
      },
      onLoading: () => const Center(child: CircularProgressIndicator()),
      onEmpty: () => Center(
        child: Text(trans().no_data),
      ),
      showError: true,
      showEmpty: true,
    );
  }
}
