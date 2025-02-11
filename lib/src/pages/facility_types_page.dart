import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/facility_type.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';
import '../utils/routes.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  FacilityTypesPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilityTypesProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilityTypesState = ref.watch(facilityTypesProvider);

    return Scaffold(
      body: ViewWidget<List<FacilityType>>(
        meta: facilityTypesState.meta,
        data: facilityTypesState.data,
        onLoaded: (data) {
          return buildFacilityTypesGrid(context);
        },
        onLoading: () => Center(child: CircularProgressIndicator()),
        onEmpty: () => const Center(child: Text('لا توجد أقسام متاحة حالياً.')),
        requireLogin: false,
        showError: true,
        showEmpty: true,
      ),
    );
  }

  Widget buildFacilityTypesGrid(BuildContext context) {
    final List<Map<String, String>> facilityTypes = [
      {'name': 'شاليهات', 'image': chaletImage, 'route': Routes.chalets},
      {'name': 'فنادق', 'image': hotelImage, 'route': Routes.hotels},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            trans().facilityTypes,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: CustomTheme.primaryColor,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1,
            ),
            itemCount: facilityTypes.length,
            itemBuilder: (context, index) {
              final facilityType = facilityTypes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, facilityType['route']!);
                },
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          facilityType['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      facilityType['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CustomTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
