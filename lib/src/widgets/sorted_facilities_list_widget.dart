import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../enums/facility_sort_type.dart';
import '../helpers/general_helper.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import 'facility_shimmer_card.dart';
import 'facility_widget.dart';

class SortedFacilitiesListWidget extends ConsumerWidget {
  final String sortKey;
  final int facilityTypeId;
  final FacilitySortType currentSort;

  const SortedFacilitiesListWidget({
    super.key,
    required this.sortKey,
    required this.facilityTypeId,
    required this.currentSort,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedAsyncValue = ref.watch(sortedFacilitiesProvider(sortKey));
    final colorScheme = Theme.of(context).colorScheme;

    // Loading
    if (sortedAsyncValue.isLoading()) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Insets.m16, vertical: S.h(12)),
        itemCount: 5,
        itemBuilder: (_, __) => const FacilityShimmerCard(),
      );
    }

    // Error
    if (sortedAsyncValue.isError()) {
      return Center(
        child: Text(
          'خطأ: ${sortedAsyncValue.message()}',
          style: TextStyle(color: colorScheme.error),
        ),
      );
    }

    final allFacilities = sortedAsyncValue.data ?? [];
    final facilities = allFacilities
        .where((f) => f.facilityTypeId == facilityTypeId)
        .toList();

    final title = facilityTypeId == 1
        ? (currentSort == FacilitySortType.lowestPrice
        ? trans().hotel_sorted_by_lowest_price
        : trans().hotel_sorted_by_highest_price)
        : facilityTypeId == 2
        ? (currentSort == FacilitySortType.lowestPrice
        ? trans().chalet_sorted_by_lowest_price
        : trans().chalet_sorted_by_highest_price)
        : (currentSort == FacilitySortType.lowestPrice
        ? trans().hall_sorted_by_lowest_price
        : trans().hall_sorted_by_highest_price);

    print("facilityTypeId from widget: $facilityTypeId");
    print("first facility type: ${allFacilities.isNotEmpty ? allFacilities.first.facilityTypeId : 'empty'}");

    // Empty
    if (facilities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(inboxIconSvg, width: S.w(140), height: S.h(140)),
            Gaps.h12,
            Text(
              trans().no_matching_facilities,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TFont.l16,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    // Content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          EdgeInsets.only(bottom: S.h(10), left: Insets.m16, right: Insets.m16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: TFont.s12,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: Insets.m16),
            itemCount: facilities.length,
            itemBuilder: (_, index) => FacilityWidget(facility: facilities[index]),
          ),
        ),
      ],
    );
  }
}
