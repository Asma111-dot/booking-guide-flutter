import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/facility.dart';
import '../providers/facility/facility_provider.dart';
import '../utils/theme.dart';
import '../widgets/favorites_card.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  final int userId;
  final int facilityTypeId;

  const FavoritesPage({Key? key, required this.userId, required this.facilityTypeId}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesPage> {
  int selectedType = 0; // 0 = الكل، 1 = فنادق، 2 = شاليهات

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(facilitiesProvider(FacilityTarget.favorites).notifier).fetch(userId: widget.userId, facilityTypeId: widget.facilityTypeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesState = ref.watch(facilitiesProvider(FacilityTarget.favorites));

    List<Facility> filteredFacilities = facilitiesState.data ?? [];
    if (selectedType == 1) {
      filteredFacilities = filteredFacilities.where((facility) => facility.facilityTypeId == 1).toList();
    } else if (selectedType == 2) {
      filteredFacilities = filteredFacilities.where((facility) => facility.facilityTypeId == 2).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("المفضلة"),
        backgroundColor: CustomTheme.primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilterButtons(),
          const SizedBox(height: 10),
          Expanded(
            child: facilitiesState.isLoading()
                ? const Center(child: CircularProgressIndicator())
                : facilitiesState.isError()
                ? Center(child: Text("حدث خطأ: ${facilitiesState.message()}"))
                : facilitiesState.data != null && facilitiesState.data!.isNotEmpty
                ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: facilitiesState.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FavoriteCard(facility: facilitiesState.data![index]),
                );
              },
            )
                : const Center(child: Text("لا توجد منشآت في المفضلة")),
          ),
        ],
      ),
    );
  }

  /// ✅ **أزرار تصفية المنشآت**
  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTypeButton("الكل", 0, Icons.border_all),
          const SizedBox(width: 10),
          _buildTypeButton("شاليهات", 2, Icons.pool),
          const SizedBox(width: 10),
          _buildTypeButton("فنادق", 1, Icons.hotel),
        ],
      ),
    );
  }

  /// ✅ **زر تصفية حسب النوع**
  Widget _buildTypeButton(String title, int type, IconData icon) {
    final bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => selectedType = type);
      },
      child: Chip(
        label: Text(title),
        avatar: Icon(icon, color: isSelected ? Colors.white : CustomTheme.primaryColor),
        backgroundColor: isSelected ? CustomTheme.primaryColor : Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : CustomTheme.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}