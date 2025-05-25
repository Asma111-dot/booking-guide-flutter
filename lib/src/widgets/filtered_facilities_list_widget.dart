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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final provider = filteredFacilitiesProvider(filters);
    final filtered = ref.watch(provider);

    if (filtered.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filtered.isError()) {
      return Center(
        child: Text(
          filtered.message(),
          style: TextStyle(
            color: colorScheme.error,
            fontSize: 14,
          ),
        ),
      );
    }

    final facilities = filtered.data ?? [];

    if (facilities.isEmpty) {
      return Center(
        child: Text(
          trans().no_matching_facilities,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      children: [
        if (selectedFilter != null && values[selectedFilter] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Text(
              buildFilterDescription(
                selectedFilter!,
                values[selectedFilter],
              ),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        const SizedBox(height: 10),
        ...facilities.map(
              (facility) {
            return FacilityWidget(
              facility: facility,
              minPriceFilter:
              minPrice != null ? double.tryParse(minPrice!) : null,
              maxPriceFilter:
              maxPrice != null ? double.tryParse(maxPrice!) : null,
            );
          },
        ),
      ],
    );
  }
}
