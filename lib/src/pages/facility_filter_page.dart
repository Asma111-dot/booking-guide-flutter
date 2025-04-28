import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/facility_filter_type.dart';
import '../enums/facility_sort_type.dart';
import '../helpers/filter_helpers.dart';
import '../helpers/general_helper.dart';
import '../providers/filter/filtered_facilities_provider.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../providers/sort/sort_key_provider.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/facility_widget.dart';

class FacilityFilterPage extends ConsumerStatefulWidget {
  final int initialFacilityTypeId;

  const FacilityFilterPage({super.key, required this.initialFacilityTypeId});

  @override
  ConsumerState<FacilityFilterPage> createState() => _FacilityFilterPageState();
}

class _FacilityFilterPageState extends ConsumerState<FacilityFilterPage> with SingleTickerProviderStateMixin {
  FacilityFilterType? selectedFilter;
  final Map<FacilityFilterType, dynamic> values = {};
  final textController = TextEditingController();
  final dateRange = ValueNotifier<DateTimeRange?>(null);
  FacilitySortType currentSort = FacilitySortType.lowestPrice;
  bool showResults = false;
  Map<String, String>? currentFilters;
  late TabController _tabController;
  bool isSorting = false;

  @override
  void initState() {
    super.initState();
    values[FacilityFilterType.facilityTypeId] = widget.initialFacilityTypeId;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.initialFacilityTypeId == 1 ? 0 : 1;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _onTabChanged(_tabController.index);
    });
  }

  void _onApplyFilters() {
    final filters = facilityFilters(
      name: values[FacilityFilterType.name],
      addressLike: values[FacilityFilterType.addressLike],
      checkInBetween: values[FacilityFilterType.checkInBetween],
      addressNearUser: values[FacilityFilterType.addressNearUser],
      capacityAtLeast: values[FacilityFilterType.capacityAtLeast],
      availableOnDay: values[FacilityFilterType.availableOnDay],
      facilityTypeId: values[FacilityFilterType.facilityTypeId],
    );

    if (mapEquals(currentFilters, filters)) {
      ref.read(filteredFacilitiesProvider(currentFilters!).notifier).fetch();
      return;
    }

    setState(() {
      showResults = true;
      currentFilters = filters;
    });

    ref.read(filteredFacilitiesProvider(filters).notifier).fetch();
  }

  void _onTabChanged(int index) {
    setState(() {
      values[FacilityFilterType.facilityTypeId] = (index == 0 ? 1 : 2);
    });
    _onApplyFilters();
  }

  @override
  void dispose() {
    _tabController.dispose();
    textController.dispose();
    dateRange.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appTitle: '',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: CustomTheme.primaryColor,
              labelColor: CustomTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: trans().hotel),
                Tab(text: trans().chalet),
              ],
            ),
            const SizedBox(height: 16),
            _buildSearchFilters(),
            const Divider(height: 32),
            _buildSortControls(),
            const SizedBox(height: 16),
            Expanded(
              child: showResults
                  ? _buildFilteredList()
                  : isSorting
                  ? _buildSortedList()
                  : _buildDefaultList(), // ✅ نعرض داتا عادية بدون ترتيب
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFilters() {
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
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<FacilityFilterType>(
                isExpanded: true,
                hint: const Text('اختر الفلتر', overflow: TextOverflow.ellipsis),
                value: selectedFilter,
                icon: const Icon(Icons.arrow_drop_down),
                items: FacilityFilterType.values
                    .where((f) => f != FacilityFilterType.facilityTypeId)
                    .map((f) => DropdownMenuItem(
                  value: f,
                  child: Text(f.label, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value;
                    if (value != null && !values.containsKey(value)) {
                      values[value] = null;
                    }
                  });
                },
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
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
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
                    onChanged: (value) {
                      if (selectedFilter != null) {
                        values[selectedFilter!] = value;
                        _onApplyFilters();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${currentSort.label}', style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(currentSort == FacilitySortType.lowestPrice ? Icons.arrow_downward : Icons.arrow_upward),
          tooltip: 'تغيير نوع الفرز',
          onPressed: () {
            setState(() {
              isSorting = true; // ✅ علمنا أنه يريد ترتيب
              currentSort = currentSort == FacilitySortType.lowestPrice
                  ? FacilitySortType.highestPrice
                  : FacilitySortType.lowestPrice;
            });
            final newSortKey = currentSort == FacilitySortType.lowestPrice ? 'price' : '-price';
            ref.read(sortKeyProvider.notifier).state = newSortKey;
          },
        )
      ],
    );
  }

  Widget _buildFilteredList() {
    return Consumer(
      builder: (context, ref, _) {
        final provider = filteredFacilitiesProvider(currentFilters!);
        final filtered = ref.watch(provider);

        if (filtered.isLoading()) return const Center(child: CircularProgressIndicator());
        if (filtered.isError()) return Center(child: Text(filtered.message()));
        final facilities = filtered.data ?? [];

        if (facilities.isEmpty) return const Center(child: Text('لا توجد منشآت مطابقة للبحث'));

        return ListView.builder(
          itemCount: facilities.length,
          itemBuilder: (_, index) => FacilityWidget(facility: facilities[index]),
        );
      },
    );
  }

  Widget _buildSortedList() {
    final sortKey = ref.watch(sortKeyProvider);
    final sortedAsyncValue = ref.watch(sortedFacilitiesProvider(sortKey));

    if (sortedAsyncValue.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (sortedAsyncValue.isError()) {
      return Center(child: Text('خطأ: ${sortedAsyncValue.message()}'));
    }

    final facilities = sortedAsyncValue.data ?? [];

    if (facilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }

    return ListView.builder(
      itemCount: facilities.length,
      itemBuilder: (_, index) {
        final facility = facilities[index];
        return FacilityWidget(facility: facility);
      },
    );
  }

  Widget _buildDefaultList() {
    final sortedAsyncValue = ref.watch(sortedFacilitiesProvider('')); // لاحظ: نرسل مفتاح فاضي يعني بدون ترتيب

    if (sortedAsyncValue.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (sortedAsyncValue.isError()) {
      return Center(child: Text('خطأ: ${sortedAsyncValue.message()}'));
    }

    final facilities = sortedAsyncValue.data ?? [];

    if (facilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }

    return ListView.builder(
      itemCount: facilities.length,
      itemBuilder: (_, index) {
        final facility = facilities[index];
        return FacilityWidget(facility: facility);
      },
    );
  }
}
