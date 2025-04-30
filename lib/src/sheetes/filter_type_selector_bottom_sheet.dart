import 'package:flutter/material.dart';

import '../enums/facility_filter_type.dart';
import '../utils/theme.dart';

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
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.6,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            const Text('اختر نوع الفلتر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filters.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return ListTile(
                    leading: Icon(filter.icon, color: CustomTheme.primaryColor),
                    title: Text(filter.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(filter.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    onTap: () {
                      Navigator.pop(context);
                      onSelect(filter);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
