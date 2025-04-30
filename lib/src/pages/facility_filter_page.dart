import 'package:booking_guide/src/extensions/date_formatting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

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
    if (priceBetween != null && priceBetween is String && priceBetween.contains(',')) {
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
            _buildSearchFilters(),
            if (values.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      values.removeWhere((key, value) => key != FacilityFilterType.facilityTypeId);
                      showResults = false;
                      textController.clear();
                    });
                  },
                  icon: const Icon(Icons.refresh, color: Colors.red),
                  label: const Text('إعادة تعيين الفلاتر', style: TextStyle(color: Colors.grey)),
                ),
              ),
            const Divider(height: 32),
            _buildSortControls(),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: showResults
                    ? _buildFilteredList()
                    : (isSorting
                        ? _buildSortedList()
                        : _buildTabFilteredList()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabFilteredList() {
    final allFacilitiesAsync = ref.watch(sortedFacilitiesProvider(''));

    if (allFacilitiesAsync.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }
    if (allFacilitiesAsync.isError()) {
      return Center(child: Text('خطأ: ${allFacilitiesAsync.message()}'));
    }

    final allFacilities = allFacilitiesAsync.data ?? [];
    final facilityTypeId = values[FacilityFilterType.facilityTypeId];

    final filteredFacilities =
        allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    if (filteredFacilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }

    final title = facilityTypeId == 1
        ? 'جميع الفنادق المتوفرة'
        : 'جميع الشاليهات المتوفرة';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFacilities.length,
            itemBuilder: (_, index) {
              final facility = filteredFacilities[index];
              return FacilityWidget(facility: facility);
            },
          ),
        ),
      ],
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
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
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
                BoxShadow(
                    color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))
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
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          showResults = false;
                          values[selectedFilter!] = null;
                        });
                      } else {
                        if (selectedFilter != null) {
                          setState(() {
                            values[selectedFilter!] = value;
                          });
                          _onApplyFilters();
                        }
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

  Widget _buildFilteredList() {
    return Consumer(
      builder: (context, ref, _) {
        final provider = filteredFacilitiesProvider(currentFilters!);
        final filtered = ref.watch(provider);

        if (filtered.isLoading()) {
          return const Center(child: CircularProgressIndicator());
        }
        if (filtered.isError()) {
          return Center(child: Text(filtered.message()));
        }

        final facilities = filtered.data ?? [];

        if (facilities.isEmpty) {
          return const Center(child: Text('لا توجد منشآت مطابقة للبحث'));
        }

        final facilityTypeId = values[FacilityFilterType.facilityTypeId];
        final filterDate = values[FacilityFilterType.availableOnDay];

        String title = '';

        if (filterDate != null) {

          for (var facility in facilities) {
            for (var room in facility.rooms) {
              for (var price in room.roomPrices) {
                if ((price.reservations.isNotEmpty ?? false)) {
                  break;
                }
              }
            }
          }

          final typeLabel = facilityTypeId == 1 ? 'الفنادق' : 'الشاليهات';
          title = '$typeLabel المتوفرة في تاريخ $filterDate';
        } else {
          final typeLabel = facilityTypeId == 1 ? 'الفنادق' : 'الشاليهات';
          title = '$typeLabel المتوفرة';
        }


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: facilityTypeId == 1
                                    ? 'الفنادق المتوفرة'
                                    : 'الشاليهات المتوفرة',
                              ),
                              if (filterDate != null) ...[
                                const TextSpan(text: ' في تاريخ: '),
                                TextSpan(
                                  text: filterDate,
                                  style: TextStyle(
                                    color: CustomTheme.primaryColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (filterDate != null)
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                        ),
                    ],
                  ),

                  // ✅ رسالة إضافية حسب الفلتر
                  if (selectedFilter != null && values[selectedFilter] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _buildFilterDescription(selectedFilter!, values[selectedFilter]),
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: facilities.length,
                itemBuilder: (_, index) {
                  final facility = facilities[index];
                  return FacilityWidget(
                    facility: facility,
                    minPriceFilter: minPriceFilter != null ? double.tryParse(minPriceFilter!) : null,
                    maxPriceFilter: maxPriceFilter != null ? double.tryParse(maxPriceFilter!) : null,
                  );
                },
              ),
            ),
          ],
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

    final allFacilities = sortedAsyncValue.data ?? [];

    final facilityTypeId = values[FacilityFilterType.facilityTypeId];

    final facilities =
        allFacilities.where((f) => f.facilityTypeId == facilityTypeId).toList();

    final title = facilityTypeId == 1
        ? 'الفنادق مرتبة حسب السعر'
        : 'الشاليهات مرتبة حسب السعر';

    if (facilities.isEmpty) {
      return const Center(child: Text('لا توجد منشآت متاحة'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: facilities.length,
            itemBuilder: (_, index) {
              final facility = facilities[index];
              return FacilityWidget(facility: facility);
            },
          ),
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
                const Text(
                  'اختر نوع الفلتر',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      return ListTile(
                          leading: Icon(filter.icon,
                              color: CustomTheme.primaryColor),
                          title: Text(
                            filter.label,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            filter.description,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        onTap: () async {
                          if (filter == FacilityFilterType.name ||
                              filter == FacilityFilterType.addressLike) {
                            setState(() {
                              selectedFilter = filter;
                            });
                            Navigator.pop(context);
                          } else if (filter == FacilityFilterType.addressNearUser) {
                            Navigator.pop(context); // أغلق اختيار الفلتر
                            _showUserAddressBottomSheet(); // افتح إدخال العنوان
                          } else {
                            Navigator.pop(context);
                            _openValueBottomSheet(filter);
                          }
                        },
                          );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openValueBottomSheet(FacilityFilterType filter) {
    switch (filter) {
      case FacilityFilterType.priceBetween:
        _showPriceRangeBottomSheet();
        break;
      // case FacilityFilterType.checkInBetween:
      //   //  _showDateRangeBottomSheet();
      //   break;
      case FacilityFilterType.capacityAtLeast:
         _showCapacityBottomSheet();
        break;
      case FacilityFilterType.availableOnDay:
         _showAvailableDayBottomSheet();
        break;
      default:
        // لا شيء
        break;
    }
  }

  void _showPriceRangeBottomSheet() {
    final minPriceController = TextEditingController();
    final maxPriceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + 16, // ✅ دعم الكيبورد
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'حدد نطاق السعر',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: minPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'أقل سعر',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: maxPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'أعلى سعر',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final min = minPriceController.text.trim();
                      final max = maxPriceController.text.trim();

                      if (min.isEmpty || max.isEmpty) {
                        Navigator.pop(context);
                        return;
                      }

                      setState(() {
                        final englishMin = toEnglishNumbers(min);
                        final englishMax = toEnglishNumbers(max);
                        values[FacilityFilterType.priceBetween] = '$englishMin,$englishMax';
                        selectedFilter = FacilityFilterType.priceBetween;
                      });

                      Navigator.pop(context);
                      _onApplyFilters();
                    },
                    child: const Text('تطبيق الفلترة'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCapacityBottomSheet() {
    final capacityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16, // ✅ دعم الكيبورد
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'حدد عدد الأشخاص',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]'))],
                  decoration: const InputDecoration(
                    labelText: 'عدد الأشخاص',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final people = capacityController.text.trim();

                      if (people.isEmpty) {
                        Navigator.pop(context);
                        return;
                      }

                      setState(() {
                        final englishPeople = toEnglishNumbers(people);
                        values[FacilityFilterType.capacityAtLeast] = englishPeople;
                        selectedFilter = FacilityFilterType.capacityAtLeast;
                      });

                      Navigator.pop(context);
                      _onApplyFilters();
                    },
                    child: const Text('تطبيق الفلترة'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAvailableDayBottomSheet() {
    final selectedDate = ValueNotifier<DateTime?>(null);
    final TextEditingController _controller = TextEditingController();
    DateTime today = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'حدد يوم التوفر',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// ✅ مربع النص فقط (لا كتابة)
                ValueListenableBuilder<DateTime?>(
                  valueListenable: selectedDate,
                  builder: (context, value, _) {
                    return TextFormField(
                      controller: _controller,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'اختر التاريخ',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            DateTime tempSelected = selectedDate.value ?? today;

                            return AlertDialog(
                              title: const Text('اختر التاريخ'),
                              content: SizedBox(
                                height: 300,
                                width: double.maxFinite,
                                child: dp.DayPicker.single(
                                  selectedDate: tempSelected,
                                  onChanged: (date) {
                                    tempSelected = date;
                                    Navigator.of(context).pop(date); // إغلاق وتمريرة
                                  },
                                  firstDate: today,
                                  lastDate: DateTime(2100),
                                  datePickerStyles: dp.DatePickerRangeStyles(
                                    selectedDateStyle: const TextStyle(color: Colors.white),
                                    selectedSingleDateDecoration: BoxDecoration(
                                      color: CustomTheme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).then((picked) {
                          if (picked != null && picked is DateTime) {
                            selectedDate.value = picked;
                            _controller.text = picked.toSqlDateOnly();
                          }
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDate.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('الرجاء اختيار تاريخ أولاً'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        final englishDate = toEnglishNumbers(
                          selectedDate.value!.toSqlDateOnly(),
                        );
                        values[FacilityFilterType.availableOnDay] = englishDate;
                        selectedFilter = FacilityFilterType.availableOnDay;
                      });

                      Navigator.pop(context);
                      _onApplyFilters();
                    },
                    child: const Text('تطبيق الفلترة'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUserAddressBottomSheet() {
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'أدخل عنوانك الحالي',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان المطابق للعنوانك',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final userAddress = addressController.text.trim();
                      if (userAddress.isNotEmpty) {
                        setState(() {
                          values[FacilityFilterType.addressNearUser] = userAddress;
                          selectedFilter = FacilityFilterType.addressNearUser;
                        });
                        Navigator.pop(context);
                        _onApplyFilters();
                      }
                    },
                    child: const Text('تطبيق الفلترة'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildFilterDescription(FacilityFilterType filter, dynamic value) {
    switch (filter) {
      case FacilityFilterType.name:
        return 'تمت التصفية حسب الاسم الذي يحتوي: "$value"';
      case FacilityFilterType.addressLike:
        return 'تمت التصفية حسب العنوان الذي يحتوي: "$value"';
      case FacilityFilterType.capacityAtLeast:
        return 'تمت التصفية لعدد أشخاص لا يقل عن $value';
      case FacilityFilterType.priceBetween:
        final parts = value.split(',');
        return 'تمت التصفية لأسعار بين ${parts[0]} و ${parts[1]}';
      case FacilityFilterType.availableOnDay:
        return 'تمت التصفية حسب اليوم المتاح';
      case FacilityFilterType.addressNearUser:
        return 'تمت التصفية حسب موقعك الحالي (قريب من "$value")';
      default:
        return '';
    }
  }

}
