import 'package:flutter/material.dart';
import '../enums/facility_filter_type.dart';

class SearchFilterBar extends StatelessWidget {
  final FacilityFilterType? selectedFilter;
  final TextEditingController textController;
  final Function() onOpenFilter;
  final Function(String value) onSearchChanged;

  const SearchFilterBar({
    super.key,
    required this.selectedFilter,
    required this.textController,
    required this.onOpenFilter,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
              ],
            ),
            child: GestureDetector(
              onTap: onOpenFilter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedFilter?.label ?? 'اختر الفلتر',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'ابحث...',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
