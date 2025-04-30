import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../enums/facility_filter_type.dart';
import '../enums/facility_sort_type.dart';
import '../helpers/filter_helpers.dart';
import '../helpers/general_helper.dart';
import '../providers/filter/filtered_facilities_provider.dart';
import '../providers/sort/sort_key_provider.dart';
import '../sheetes/address_near_user_filter_sheet.dart';
import '../sheetes/available_day_filter_sheet.dart';
import '../sheetes/capacity_filter_sheet.dart';
import '../sheetes/filter_type_selector_bottom_sheet.dart';
import '../sheetes/price_filter_sheet.dart';
import '../sheetes/search_filter_bar.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/filtered_facilities_list_widget.dart';

class FacilityFilterPage extends ConsumerStatefulWidget {
  final int initialFacilityTypeId;

  const FacilityFilterPage({super.key, required this.initialFacilityTypeId});

  @override
  ConsumerState<FacilityFilterPage> createState() => _FacilityFilterPageState();
}

class _FacilityFilterPageState extends ConsumerState<FacilityFilterPage>
    with SingleTickerProviderStateMixin {
  FacilityFilterType? selectedFilter;
  final Map<FacilityFilterType, dynamic> values = {};
  final textController = TextEditingController();
  final dateRange = ValueNotifier<DateTimeRange?>(null);
  FacilitySortType currentSort = FacilitySortType.lowestPrice;
  bool showResults = false;
  Map<String, String>? currentFilters;
  late TabController _tabController;
  bool isSorting = false;
  bool tabChanged = false;
  String? minPriceFilter;
  String? maxPriceFilter;

  @override
  void initState() {
    super.initState();
    values[FacilityFilterType.facilityTypeId] = 1; // ✅ نبدأ بعرض الفنادق فقط
    selectedFilter = FacilityFilterType.name;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _onTabChanged(_tabController.index);
    });
  }

  void _onApplyFilters() {
    final filters = facilityFilters(
      name: values[FacilityFilterType.name],
      addressLike: values[FacilityFilterType.addressLike],
      // checkInBetween: values[FacilityFilterType.checkInBetween],
      addressNearUser: values[FacilityFilterType.addressNearUser],
      capacityAtLeast: values[FacilityFilterType.capacityAtLeast],
      availableOnDay: values[FacilityFilterType.availableOnDay],
      priceBetween: values[FacilityFilterType.priceBetween],
      facilityTypeId: values[FacilityFilterType.facilityTypeId],
    );

    final priceBetween = values[FacilityFilterType.priceBetween];
    if (priceBetween != null &&
        priceBetween is String &&
        priceBetween.contains(',')) {
      final parts = priceBetween.split(',');
      minPriceFilter = parts[0];
      maxPriceFilter = parts[1];
    } else {
      minPriceFilter = null;
      maxPriceFilter = null;
    }

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
      tabChanged = true;
      isSorting = false;
      showResults = false;

      values[FacilityFilterType.facilityTypeId] = (index == 0 ? 1 : 2);

      textController.clear(); // ✅ تصفير مربع البحث
      selectedFilter = FacilityFilterType.name; // ✅ إرجاع البحث بالاسم دائمًا
    });
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trans().discoverBestPlace,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trans().searchByNameAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
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
            const SizedBox(height: 10),
            SearchFilterBar(
              selectedFilter: selectedFilter,
              textController: textController,
              onOpenFilter: _openFilterBottomSheet,
              onSearchChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    showResults = false;
                    values[selectedFilter!] = null;
                  });
                } else if (selectedFilter != null) {
                  setState(() {
                    values[selectedFilter!] = value;
                  });
                  _onApplyFilters();
                }
              },
            ),
            if (values.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      values.removeWhere((key, value) =>
                          key != FacilityFilterType.facilityTypeId);
                      showResults = false;
                      textController.clear();
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  label: const Text('إعادة تعيين الفلاتر',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            const Divider(height: 32),
            _buildSortControls(),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showResults
                    ? FilteredFacilitiesListWidget(
                        filters: currentFilters!,
                        values: values,
                        selectedFilter: selectedFilter,
                        minPrice: minPriceFilter,
                        maxPrice: maxPriceFilter,
                      )
                    : (isSorting
                        ? SortedFacilitiesListWidget(
                            sortKey: ref.watch(sortKeyProvider),
                            facilityTypeId:
                                values[FacilityFilterType.facilityTypeId],
                          )
                        : TabFilteredFacilitiesListWidget(
                  facilityTypeId: values[FacilityFilterType.facilityTypeId],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSortControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(currentSort.label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
          icon: Icon(currentSort == FacilitySortType.lowestPrice
              ? Icons.arrow_downward
              : Icons.arrow_upward),
          tooltip: 'تغيير نوع الفرز',
          onPressed: () {
            setState(() {
              isSorting = true; // ✅ علمنا أنه يريد ترتيب
              currentSort = currentSort == FacilitySortType.lowestPrice
                  ? FacilitySortType.highestPrice
                  : FacilitySortType.lowestPrice;
            });
            final newSortKey = currentSort == FacilitySortType.lowestPrice
                ? 'price'
                : '-price';
            ref.read(sortKeyProvider.notifier).state = newSortKey;
          },
        )
      ],
    );
  }

  void _openFilterBottomSheet() {
    final filters = FacilityFilterType.values
        .where((f) => f != FacilityFilterType.facilityTypeId && f != FacilityFilterType.checkInBetween)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return FilterTypeSelectorBottomSheet(
          filters: filters,
          onSelect: (filter) {
            if (filter == FacilityFilterType.name || filter == FacilityFilterType.addressLike) {
              setState(() {
                selectedFilter = filter;
              });
            } else if (filter == FacilityFilterType.addressNearUser) {
              showAddressNearUserBottomSheet(
                context: context,
                onSelected: (value) {
                  setState(() {
                    values[FacilityFilterType.addressNearUser] = value;
                    selectedFilter = FacilityFilterType.addressNearUser;
                  });
                  _onApplyFilters();
                },
              );
            } else {
              _openValueBottomSheet(filter);
            }
          },
        );
      },
    );
  }


  void _openValueBottomSheet(FacilityFilterType filter) {
    switch (filter) {
      case FacilityFilterType.priceBetween:
        showPriceRangeBottomSheet(
          context: context,
          onSelected: (value) {
            setState(() {
              values[FacilityFilterType.priceBetween] = value;
              selectedFilter = FacilityFilterType.priceBetween;
            });
            _onApplyFilters();
          },
        );
        break;

      case FacilityFilterType.capacityAtLeast:
        showCapacityBottomSheet(
          context: context,
          onSelected: (value) {
            setState(() {
              values[FacilityFilterType.capacityAtLeast] = value;
              selectedFilter = FacilityFilterType.capacityAtLeast;
            });
            _onApplyFilters();
          },
        );
        break;

      case FacilityFilterType.availableOnDay:
        showAvailableDayBottomSheet(
          context: context,
          onSelected: (value) {
            setState(() {
              values[FacilityFilterType.availableOnDay] = value;
              selectedFilter = FacilityFilterType.availableOnDay;
            });
            _onApplyFilters();
          },
        );
        break;

      default:
        break;
    }
  }
}
