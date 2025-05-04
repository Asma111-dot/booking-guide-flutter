import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/filtered_facilities_list_widget.dart';
import '../widgets/sorted_facilities_list_widget.dart';
import '../widgets/tab_filtered_facilities_list_widget.dart';

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

      textController.clear();
      selectedFilter = FacilityFilterType.name;
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
        icon: arrowBackIcon,
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
                  const SizedBox(height: 4),
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
              indicatorColor: CustomTheme.color2,
              labelColor: CustomTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: trans().hotel),
                Tab(text: trans().chalet),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // زر اختيار نوع الفلتر
                Flexible(
                  flex: 2,
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _openFilterBottomSheet,
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
                          const Icon(Icons.arrow_drop_down,color: CustomTheme.color2,),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // مربع البحث
                Flexible(
                  flex: 6,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: trans().search_in_facilities,
                      prefixIcon: const Icon(Icons.search,color: CustomTheme.color2,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                    ),
                    onChanged: (value) {
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
                ),
                const SizedBox(width: 10),

                // زر الفلترة
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSorting = true;
                        currentSort =
                            currentSort == FacilitySortType.lowestPrice
                                ? FacilitySortType.highestPrice
                                : FacilitySortType.lowestPrice;
                      });
                      final newSortKey =
                          currentSort == FacilitySortType.lowestPrice
                              ? 'price'
                              : '-price';
                      ref.read(sortKeyProvider.notifier).state = newSortKey;
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: CustomTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        key: ValueKey(currentSort),
                        currentSort == FacilitySortType.lowestPrice
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (values.length > 1 || isSorting)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      values.removeWhere((key, value) =>
                      key != FacilityFilterType.facilityTypeId);
                      showResults = false;
                      textController.clear();

                      currentSort = FacilitySortType.lowestPrice;
                      isSorting = false;

                      ref.read(sortKeyProvider.notifier).state = 'price';
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  label:  Text(
                    trans().reset_filters,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            const Divider(height: 32),
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
                            currentSort: currentSort,
                          )
                        : TabFilteredFacilitiesListWidget(
                            facilityTypeId:
                                values[FacilityFilterType.facilityTypeId],
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openFilterBottomSheet() {
    final filters = FacilityFilterType.values
        .where((f) =>
            f != FacilityFilterType.facilityTypeId &&
            f != FacilityFilterType.checkInBetween)
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
            if (filter == FacilityFilterType.name ||
                filter == FacilityFilterType.addressLike) {
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
