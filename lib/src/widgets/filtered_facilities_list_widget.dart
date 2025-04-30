import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/facility_filter_type.dart';
import '../providers/filter/filtered_facilities_provider.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../utils/theme.dart';
import 'facility_widget.dart';

class FilteredFacilitiesListWidget extends ConsumerWidget {
  final Map<String, String> filters;
  final Map<FacilityFilterType, dynamic> values;
  final FacilityFilterType? selectedFilter;
  final String? minPrice;
  final String? maxPrice;

  const FilteredFacilitiesListWidget({
    super.key,
    required this.filters,
    required this.values,
    required this.selectedFilter,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = filteredFacilitiesProvider(filters);
    final filtered = ref.watch(provider);

    if (filtered.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filtered.isError()) {
      return Center(child: Text(filtered.message()));
    }

    final facilities = filtered.data ?? [];

    if (facilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت مطابقة للبحث'));
    }

    final facilityTypeId = values[FacilityFilterType.facilityTypeId];
    final filterDate = values[FacilityFilterType.availableOnDay];

    final typeLabel = facilityTypeId == 1 ? 'الفنادق' : 'الشاليهات';
    final title = filterDate != null ? '$typeLabel المتوفرة في تاريخ $filterDate' : '$typeLabel المتوفرة';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: typeLabel + ' المتوفرة'),
                          if (filterDate != null) ...[
                            const TextSpan(text: ' في تاريخ: '),
                            TextSpan(
                              text: filterDate,
                              style: TextStyle(color: CustomTheme.primaryColor, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (filterDate != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                    ),
                ],
              ),
              if (selectedFilter != null && values[selectedFilter] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    buildFilterDescription(selectedFilter!, values[selectedFilter]),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (_, index) {
              final facility = facilities[index];
              return FacilityWidget(
                facility: facility,
                minPriceFilter: minPrice != null ? double.tryParse(minPrice!) : null,
                maxPriceFilter: maxPrice != null ? double.tryParse(maxPrice!) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SortedFacilitiesListWidget extends ConsumerWidget {
  final String sortKey;
  final int facilityTypeId;

  const SortedFacilitiesListWidget({
    super.key,
    required this.sortKey,
    required this.facilityTypeId,
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
    final facilities = allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = facilityTypeId == 1 ? 'الفنادق مرتبة حسب السعر' : 'الشاليهات مرتبة حسب السعر';

    if (facilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    final filteredFacilities = allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = facilityTypeId == 1 ? 'جميع الفنادق المتوفرة' : 'جميع الشاليهات المتوفرة';

    if (filteredFacilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
