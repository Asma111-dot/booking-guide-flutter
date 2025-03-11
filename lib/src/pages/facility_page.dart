import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/facility/facility_provider.dart';
import '../widgets/facility_widget.dart';
import '../widgets/view_widget.dart';
import '../models/facility.dart';

class FacilityPage extends ConsumerStatefulWidget {
  final int selectedFacilityType;

  const FacilityPage({Key? key, required this.selectedFacilityType})
      : super(key: key);

  @override
  ConsumerState createState() => _FacilityPageState();
}

class _FacilityPageState extends ConsumerState<FacilityPage> {
  FacilityTarget currentTarget = FacilityTarget.hotels;

  @override
  void initState() {
    super.initState();

    switch (widget.selectedFacilityType) {
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
          .fetch(facilityTypeId: widget.selectedFacilityType);
    });
  }

  @override
  void didUpdateWidget(covariant FacilityPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFacilityType != oldWidget.selectedFacilityType) {
      Future.microtask(() {
        ref.read(facilitiesProvider(currentTarget).notifier)
            .fetch(facilityTypeId: widget.selectedFacilityType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider(currentTarget));

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