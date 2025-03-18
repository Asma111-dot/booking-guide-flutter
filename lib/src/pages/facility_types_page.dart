import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../providers/facility_type/facility_type_provider.dart';
import '../utils/theme.dart';
import 'facility_page.dart';

class FacilityTypesPage extends ConsumerStatefulWidget {
  const FacilityTypesPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FacilityTypesPageState();
}

class _FacilityTypesPageState extends ConsumerState<FacilityTypesPage> {
  int? selectedFacilityType;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilityTypesProvider.notifier).fetch();
    });
  }

  void _onFacilityTypeChange(int facilityTypeId) {
    setState(() {
      selectedFacilityType = facilityTypeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final facilityTypesState = ref.watch(facilityTypesProvider);
    final facilityTypesState = ref.watch(facilityTypesProvider);

    if (facilityTypesState.data != null &&
        facilityTypesState.data!.isNotEmpty &&
        selectedFacilityType == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedFacilityType = facilityTypesState.data!.first.id;
        });
      });
    }

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
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: facilityTypesState.data == null ||
                    facilityTypesState.data!.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    children: facilityTypesState.data!.map((facilityType) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildTypeButtonWithIcon(
                          context,
                          facilityType.name,
                          facilityType.id,
                          facilityType.id == 1 ? Icons.hotel : Icons.pool,
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 0),
          Expanded(
            child: selectedFacilityType == null
                ? const Center(child: Text("اختر نوع المنشأة"))
                : FacilityPage(facilityTypeId: selectedFacilityType ?? 0),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButtonWithIcon(
      BuildContext context, String title, int typeId, IconData icon) {
    final bool isSelected = selectedFacilityType == typeId;
    return GestureDetector(
      onTap: () => _onFacilityTypeChange(typeId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomTheme.primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 10),
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
