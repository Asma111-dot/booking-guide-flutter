import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../enums/facility_filter_type.dart';
import '../enums/facility_sort_type.dart';
import '../helpers/filter_helpers.dart';
import '../providers/filter/filtered_facilities_provider.dart';
import '../providers/sort/sorted_facilities_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/facility_widget.dart';

class FacilityFilterPage extends ConsumerStatefulWidget {
  final int initialFacilityTypeId;

  const FacilityFilterPage({super.key, required this.initialFacilityTypeId});

  @override
  ConsumerState<FacilityFilterPage> createState() => _FacilityFilterPageState();
}

class _FacilityFilterPageState extends ConsumerState<FacilityFilterPage> {
  FacilityFilterType? selectedFilter;
  final Map<FacilityFilterType, dynamic> values = {};
  final textController = TextEditingController();
  final dateRange = ValueNotifier<DateTimeRange?>(null);

  FacilitySortType currentSort = FacilitySortType.lowestPrice;

  bool showResults = false;
  Map<String, String>? currentFilters;

  @override
  void initState() {
    super.initState();
    values[FacilityFilterType.facilityTypeId] = widget.initialFacilityTypeId.toString();
  }

  void _onApplyFilters() {
    final filters = facilityFilters(
      name: values[FacilityFilterType.name],
      addressLike: values[FacilityFilterType.addressLike],
      checkInBetween: values[FacilityFilterType.checkInBetween],
      addressNearUser: values[FacilityFilterType.addressNearUser],
      capacityAtLeast: values[FacilityFilterType.capacityAtLeast],
      availableOnDay: values[FacilityFilterType.availableOnDay],
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

  void _onResetFilters() {
    setState(() {
      selectedFilter = null;
      values.clear();
      values[FacilityFilterType.facilityTypeId] = widget.initialFacilityTypeId.toString();
      textController.clear();
      dateRange.value = null;
      showResults = false;
      currentFilters = null;
      currentSort = FacilitySortType.lowestPrice;
    });
  }

  Widget _buildFilterInput(FacilityFilterType type) {
    switch (type) {
      case FacilityFilterType.name:
      case FacilityFilterType.addressLike:
      case FacilityFilterType.addressNearUser:
        return TextField(
          controller: textController,
          decoration: InputDecoration(labelText: 'أدخل ${type.label}'),
          onChanged: (value) => values[type] = value,
        );

      case FacilityFilterType.capacityAtLeast:
        return TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'عدد الأشخاص'),
          onChanged: (value) => values[type] = value,
        );

      case FacilityFilterType.checkInBetween:
        return ValueListenableBuilder<DateTimeRange?>(
          valueListenable: dateRange,
          builder: (_, range, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    dateRange.value = picked;
                    values[type] = '${DateFormat('yyyy-MM-dd').format(picked.start)},${DateFormat('yyyy-MM-dd').format(picked.end)}';
                  }
                },
                child: const Text('اختيار الفترة'),
              ),
              if (range != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${range.start.toString().split(" ").first} → ${range.end.toString().split(" ").first}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        );

      case FacilityFilterType.availableOnDay:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  final formatted = DateFormat('yyyy-MM-dd').format(picked);
                  values[type] = formatted;
                }
              },
              child: const Text('اختر التاريخ'),
            ),
            if (values[type] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'التاريخ المختار: ${values[type]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        );

      case FacilityFilterType.facilityTypeId:
        return const SizedBox();

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'فلترة المنشآت',
        icon: const FaIcon(Icons.arrow_back_ios),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<FacilityFilterType>(
              hint: const Text('اختر نوع الفلتر'),
              value: selectedFilter,
              isExpanded: true,
              items: FacilityFilterType.values
                  .where((f) => f != FacilityFilterType.facilityTypeId)
                  .map((f) => DropdownMenuItem(
                value: f,
                child: Text(f.label),
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
            const SizedBox(height: 12),
            if (selectedFilter != null) _buildFilterInput(selectedFilter!),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ترتيب حسب السعر: ${currentSort.label}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    currentSort == FacilitySortType.lowestPrice
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                  ),
                  tooltip: 'تغيير نوع الفرز',
                  onPressed: () {
                    setState(() {
                      currentSort = currentSort == FacilitySortType.lowestPrice
                          ? FacilitySortType.highestPrice
                          : FacilitySortType.lowestPrice;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('بحث'),
              onPressed: _onApplyFilters,
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة تعيين الفلاتر'),
              onPressed: _onResetFilters,
            ),
            const SizedBox(height: 16),
            if (currentFilters != null && showResults)
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final provider = filteredFacilitiesProvider(currentFilters!);
                    final filtered = ref.watch(provider);

                    if (filtered.isLoading()) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (filtered.isError()) {
                      return Center(child: Text(filtered.message()));
                    }

                    if (filtered.data == null) {
                      return const Center(child: Text('جاري تحميل البيانات...'));
                    } else if (filtered.data!.isEmpty) {
                      return const Center(child: Text('لا توجد منشآت مطابقة للبحث'));
                    } else {
                      return ListView.builder(
                        itemCount: filtered.data!.length,
                        itemBuilder: (_, index) {
                          final facility = filtered.data![index];
                          return FacilityWidget(facility: facility);
                        },
                      );
                    }
                  },
                ),
              ),
            if (!showResults)
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final sorted = ref.watch(sortedFacilitiesProvider(
                      currentSort == FacilitySortType.lowestPrice ? 'price' : '-price',
                    ));

                    if (sorted.isLoading()) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (sorted.isError()) {
                      return Center(child: Text('خطأ: ${sorted.message()}'));
                    }

                    if (sorted.data != null && sorted.data!.isEmpty) {
                      return const Center(child: Text('لا توجد منشآت متاحة'));
                    }

                    return ListView.builder(
                      itemCount: sorted.data?.length ?? 0,
                      itemBuilder: (_, index) {
                        final facility = sorted.data![index];
                        return FacilityWidget(facility: facility);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
