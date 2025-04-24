import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../enums/facility_filter_type.dart';
import '../enums/facility_sort_type.dart';
import '../helpers/filter_helpers.dart';
import '../widgets/custom_app_bar.dart';

class FacilityFilterPage extends StatefulWidget {
  const FacilityFilterPage({super.key});

  @override
  State<FacilityFilterPage> createState() => _FacilityFilterPageState();
}

class _FacilityFilterPageState extends State<FacilityFilterPage> {
  FacilityFilterType? selectedFilter;
  final Map<FacilityFilterType, dynamic> values = {};
  final textController = TextEditingController();
  final dateRange = ValueNotifier<DateTimeRange?>(null);

  FacilitySortType currentSort = FacilitySortType.lowestPrice;

  Widget _buildFilterInput(FacilityFilterType type) {
    switch (type) {
      case FacilityFilterType.name:
      case FacilityFilterType.addressLike:
      case FacilityFilterType.addressNearUser:
        return TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'أدخل ${type.label}',
          ),
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
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    dateRange.value = picked;
                    values[type] =
                        '${DateFormat('yyyy-MM-dd').format(picked.start)},${DateFormat('yyyy-MM-dd').format(picked.end)}';
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
                )
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
              )
          ],
        );

      default:
        return const SizedBox();
    }
  }

  void _onApplyFilters() {
    final filters = facilityFilters(
      name: values[FacilityFilterType.name],
      addressLike: values[FacilityFilterType.addressLike],
      checkInBetween: values[FacilityFilterType.checkInBetween],
      addressNearUser: values[FacilityFilterType.addressNearUser],
      capacityAtLeast: values[FacilityFilterType.capacityAtLeast],
      availableOnDay: values[FacilityFilterType.availableOnDay], // ✅
      sortType: currentSort,
    );

    Navigator.pop(context, filters);
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
              items: FacilityFilterType.values.map((f) {
                return DropdownMenuItem(
                  value: f,
                  child: Text(f.label),
                );
              }).toList(),
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
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('بحث'),
              onPressed: _onApplyFilters,
            ),
          ],
        ),
      ),
    );
  }
}
