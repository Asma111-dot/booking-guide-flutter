import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/general_helper.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/assets.dart';
import 'facility_shimmer_card.dart';
import 'facility_widget.dart';

class TabFilteredFacilitiesListWidget extends ConsumerWidget {
  final int facilityTypeId;

  const TabFilteredFacilitiesListWidget({
    super.key,
    required this.facilityTypeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allFacilitiesAsync = ref.watch(sortedFacilitiesProvider(''));
    final colorScheme = Theme.of(context).colorScheme;

    if (allFacilitiesAsync.isLoading()) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: 5,
        itemBuilder: (_, __) => const FacilityShimmerCard(),
      );
    }

    if (allFacilitiesAsync.isError()) {
      return Center(
        child: Text(
          'خطأ: ${allFacilitiesAsync.message()}',
          style: TextStyle(color: colorScheme.error),
        ),
      );
    }

    final allFacilities = allFacilitiesAsync.data ?? [];
    final filteredFacilities =
    allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = facilityTypeId == 1
        ? trans().all_available_hotels
        : facilityTypeId == 2
        ? trans().all_available_chalets
        : trans().all_available_halls;


    if (filteredFacilities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              linkIconSvg,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFacilities.length,
            itemBuilder: (_, index) {
              final facility = filteredFacilities[index];
              return FacilityWidget(facility: facility);
            },
          ),
        ),
      ],
    );
  }
}
