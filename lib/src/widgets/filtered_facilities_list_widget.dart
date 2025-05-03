import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/facility_filter_type.dart';
import '../helpers/general_helper.dart';
import '../providers/filter/filtered_facilities_provider.dart';
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

    final facilityTypeId = values[FacilityFilterType.facilityTypeId];
    final filterDate = values[FacilityFilterType.availableOnDay];

    final typeLabel = facilityTypeId == 1 ? trans().hotel : trans().chalet;

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
                          TextSpan(text: '$typeLabel ${trans().available}'),
                          if (filterDate != null) ...[
                             TextSpan(text: trans().on_date),
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
