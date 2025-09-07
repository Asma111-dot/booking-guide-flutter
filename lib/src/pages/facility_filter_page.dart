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
import '../utils/sizes.dart';
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
    values[FacilityFilterType.facilityTypeId] = 1;
    selectedFilter = FacilityFilterType.name;
    _tabController = TabController(length: 3, vsync: this);
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

      values[FacilityFilterType.facilityTypeId] = (index == 0
          ? 1
          : index == 1
              ? 2
              : 3);

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        appTitle: '',
        icon: arrowBackIcon,
      ),
      body: Padding(
        padding: EdgeInsets.all(Insets.m16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: S.h(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trans().discoverBestPlace,
                    style: TextStyle(
                      fontSize: TFont.m14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Gaps.h4,
                  Text(
                    trans().searchByNameAddress,
                    style: TextStyle(
                      fontSize: TFont.xxs10,
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: colorScheme.primary,
              labelColor: colorScheme.secondary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.4),
              dividerColor: Colors.transparent,
              dividerHeight: 0,
              tabs: [
                Tab(text: trans().hotel),
                Tab(text: trans().chalet),
                Tab(text: trans().hall),
              ],
            ),
            Gaps.h6,
            Row(
              children: [
                // زر اختيار نوع الفلتر
                Flexible(
                  flex: 4,
                  child: Container(
                    height: S.h(45),
                    padding: EdgeInsets.symmetric(
                      horizontal: S.w(15),
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: Corners.md15,
                      boxShadow: [
                        BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.08),
                            blurRadius: S.r(3),
                            offset: Offset(0, S.h(2))),
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
                              style: TextStyle(
                                fontSize: TFont.xxs10,
                                fontWeight: FontWeight.w200,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(
                            dropDownIcon,
                            color: CustomTheme.color2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Gaps.w4,
                // مربع البحث
                Flexible(
                  flex: 6,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: trans().search_in_facilities,
                      hintStyle: TextStyle(
                        fontSize: TFont.xxs10,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      prefixIcon: const Icon(
                        searchIcon,
                        color: CustomTheme.color2,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: Corners.md15,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: S.w(15),
                        vertical: S.h(12),
                      ),
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
                Gaps.w8,
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
                        borderRadius: Corners.md15,
                      ),
                      child: Icon(
                        key: ValueKey(currentSort),
                        currentSort == FacilitySortType.lowestPrice
                            ? arrowdownIcon
                            : arrowupIcon,
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
                  icon: const Icon(
                    refreshIcon,
                    color: Colors.red,
                  ),
                  label: Text(
                    trans().reset_filters,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: TFont.xxs10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const Divider(height: 12),
            Gaps.h12,
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
    final theme = Theme.of(context);
    final filters = FacilityFilterType.values
        .where((f) =>
            f != FacilityFilterType.facilityTypeId &&
            f != FacilityFilterType.checkInBetween)
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
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
