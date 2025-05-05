import 'package:booking_guide/src/helpers/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/theme.dart';
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

    if (allFacilitiesAsync.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (allFacilitiesAsync.isError()) {
      return Center(child: Text('خطأ: ${allFacilitiesAsync.message()}'));
    }

    final allFacilities = allFacilitiesAsync.data ?? [];
    final filteredFacilities =
        allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = facilityTypeId == 1
        ? trans().all_available_hotels
        : trans().all_available_chalets;

    if (filteredFacilities.isEmpty) {
      return Center(
        child: Text(
          trans().no_facilities_available,
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
