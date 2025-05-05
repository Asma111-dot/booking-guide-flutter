import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/facility_sort_type.dart';
import '../helpers/general_helper.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/theme.dart';
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

    if (sortedAsyncValue.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (sortedAsyncValue.isError()) {
      return Center(child: Text('خطأ: ${sortedAsyncValue.message()}'));
    }

    final allFacilities = sortedAsyncValue.data ?? [];
    final facilities =
        allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = (facilityTypeId == 1
        ? (currentSort == FacilitySortType.lowestPrice
            ? trans().hotel_sorted_by_lowest_price
            : trans().hotel_sorted_by_highest_price)
        : (currentSort == FacilitySortType.lowestPrice
            ? trans().chalet_sorted_by_lowest_price
            : trans().chalet_sorted_by_highest_price));

    if (facilities.isEmpty) {
      return Center(
        child: Text(
          trans().no_matching_facilities,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (_, index) {
              final facility = facilities[index];
              return FacilityWidget(facility: facility);
            },
          ),
        ),
      ],
    );
  }
}
