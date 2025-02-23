import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/facility/facility_provider.dart';
import '../providers/facility/search_facility_provider.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';
import 'facility_page.dart';
import 'facility_search_page.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  FacilityTypesPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  int selectedFacilityType = 2;

  get getProvider => facilitiesProvider(FacilityTarget.maps);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getProvider.notifier).fetch(facilityTypeId: selectedFacilityType);
    });
  }

  void _onFacilityTypeChange(int facilityTypeId) {
    setState(() {
      selectedFacilityType = facilityTypeId;
    });
    ref.read(getProvider.notifier).fetch(facilityTypeId: facilityTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(getProvider);
    final searchResults = ref.watch(searchFacilitiesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().facilityTypes,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Expanded(
          //   child: FacilitySearch(),
          // ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              trans().facilityTypes,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: CustomTheme.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTypeButtonWithIcon(context, 'شاليهات', 2, Icons.pool),
                SizedBox(width: 10),
                _buildTypeButtonWithIcon(context, 'فنادق', 1, Icons.hotel),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ViewWidget<List<Facility>>(
              meta: facilitiesState.meta,
              data: searchResults.data?.isEmpty ?? true ? facilitiesState.data : searchResults.data, // إظهار نتائج البحث إذا كانت موجودة
              onLoaded: (data) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final facility = data[index];
                    return FacilityPage(facility: facility);
                  },
                );
              },
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: () => const Center(child: Text('لا توجد بيانات متاحة حالياً.')),
              showError: true,
              showEmpty: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButtonWithIcon(BuildContext context, String title, int typeId, IconData icon) {
    final bool isSelected = selectedFacilityType == typeId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFacilityType = typeId;
        });
        ref.read(facilitiesProvider(FacilityTarget.favorites).notifier).fetch(facilityTypeId: typeId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? CustomTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? CustomTheme.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../helpers/general_helper.dart';
// import '../models/facility.dart';
// import '../providers/facility/facility_provider.dart';
// import '../providers/facility/search_facility_provider.dart';
// import '../utils/theme.dart';
// import '../widgets/view_widget.dart';
// import 'facility_page.dart';
//
// class FacilityTypesPage extends ConsumerStatefulWidget {
//   FacilityTypesPage({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState createState() => _FacilityTypesPageState();
// }
//
// class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
//   int selectedFacilityType = 2;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       await ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 1);
//       await ref.read(facilitiesProvider.notifier).fetch(facilityTypeId: 2);
//       _onFacilityTypeChange(selectedFacilityType); // ✅ عرض البيانات عند فتح الصفحة
//     });
//   }
//
//   /// ✅ دالة لتغيير نوع العرض
//   void _onFacilityTypeChange(int facilityTypeId) {
//     setState(() {
//       selectedFacilityType = facilityTypeId;
//     });
//
//     if (facilityTypeId == 1 || facilityTypeId == 2) {
//       // ✅ تحميل البيانات من الكاش عند اختيار "شاليهات" أو "فنادق"
//       ref.read(facilitiesProvider.notifier).loadFromCache(facilityTypeId);
//     } else {
//       // ✅ دمج البيانات من الكاش بدون إعادة التحميل عند اختيار "الكل"
//       List<Facility> allFacilities = [
//         ...?ref.read(facilitiesProvider.notifier).cache[1]?.data,
//         ...?ref.read(facilitiesProvider.notifier).cache[2]?.data,
//       ];
//       ref.read(facilitiesProvider.notifier).setAllData(allFacilities);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final facilitiesState = ref.watch(facilitiesProvider);
//     final searchResults = ref.watch(searchFacilitiesProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           trans().facilityTypes,
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             color: CustomTheme.primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               trans().facilityTypes,
//               style: TextStyle(
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 color: CustomTheme.primaryColor,
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 _buildTypeButtonWithIcon(context, 'الكل', 0, Icons.border_all),
//                 SizedBox(width: 10),
//                 _buildTypeButtonWithIcon(context, 'شاليهات', 2, Icons.pool),
//                 SizedBox(width: 10),
//                 _buildTypeButtonWithIcon(context, 'فنادق', 1, Icons.hotel),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: ViewWidget<List<Facility>>(
//               meta: facilitiesState.meta,
//               data: searchResults.data?.isEmpty ?? true ? facilitiesState.data : searchResults.data,
//               onLoaded: (data) {
//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     final facility = data[index];
//                     return FacilityPage(facility: facility);
//                   },
//                 );
//               },
//               onLoading: () => const Center(child: CircularProgressIndicator()),
//               onEmpty: () => const Center(child: Text('لا توجد بيانات متاحة حالياً.')),
//               showError: true,
//               showEmpty: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTypeButtonWithIcon(BuildContext context, String title, int typeId, IconData icon) {
//     final bool isSelected = selectedFacilityType == typeId;
//
//     return GestureDetector(
//       onTap: () {
//         _onFacilityTypeChange(typeId);
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: BoxDecoration(
//           color: isSelected ? CustomTheme.primaryColor.withOpacity(0.1) : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? CustomTheme.primaryColor : Colors.grey,
//               size: 24,
//             ),
//             SizedBox(width: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? CustomTheme.primaryColor : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
