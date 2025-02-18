import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/facility/search_facility_provider.dart';

class FacilitySearch extends ConsumerStatefulWidget {
  FacilitySearch({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilitySearchState();
}

class _FacilitySearchState extends ConsumerState<FacilitySearch> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Provider (إذا لزم الأمر)
    Future.microtask(() {
      ref.read(searchFacilitiesProvider.notifier);
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // تنظيف الـ controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // مراقبة نتائج البحث
    final searchResults = ref.watch(searchFacilitiesProvider);

    return Row(
      children: [
        // مربع البحث
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // إضافة padding أفقي بسيط
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                // استدعاء البحث من الـ Provider
                ref.read(searchFacilitiesProvider.notifier).search(value);
              },
              decoration: InputDecoration(
                hintText: "بحث بالاسم",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0), // تخصيص padding داخل المربع
              ),
            ),
          ),
        ),
      ],
    );
  }
}
