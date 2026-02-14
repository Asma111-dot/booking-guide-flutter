import 'package:flutter/material.dart';

import '../helpers/general_helper.dart';
import '../enums/facility_filter_type.dart';

class FilterTypeSelectorBottomSheet extends StatelessWidget {
  final List<FacilityFilterType> filters;
  final void Function(FacilityFilterType filter) onSelect;

  const FilterTypeSelectorBottomSheet({
    super.key,
    required this.filters,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(bottom: bottomPad),
        color: theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              trans().choose_filter_type,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 2),

            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final filter = filters[index];
                return ListTile(
                  leading: Icon(filter.icon, color: colorScheme.secondary),
                  title: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  subtitle: Text(
                    filter.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(filter);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
