import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../enums/facility_filter_type.dart';
import '../helpers/general_helper.dart';
import '../providers/filter/filtered_facilities_provider.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import 'facility_shimmer_card.dart';
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
      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.m16,
          vertical: S.h(12),
        ),
        itemCount: 5,
        itemBuilder: (_, __) => const FacilityShimmerCard(),
      );
    }

    if (filtered.isError()) {
      return Center(
        child: Text(
          filtered.message(),
          style: TextStyle(
            color: colorScheme.error,
            fontSize: TFont.s12,
          ),
        ),
      );
    }

    final facilities = filtered.data ?? [];

    if (facilities.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              inboxIconSvg,
              width: S.w(140),
              height: S.h(140),
            ),
            Gaps.h12,
            Text(
              trans().no_matching_facilities,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: TFont.xxs10,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.only(
        top: Insets.xs8,
        bottom: Insets.xs8,
      ),
      children: [
        if (selectedFilter != null && values[selectedFilter] != null)
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Insets.s3_4,
              horizontal: Insets.s12,
            ),
            child: Text(
              buildFilterDescription(
                selectedFilter!,
                values[selectedFilter],
              ),
              style: TextStyle(
                fontSize: TFont.xxs8,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        Gaps.h12,
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
