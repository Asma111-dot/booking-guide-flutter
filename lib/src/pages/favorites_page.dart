import 'package:booking_guide/src/widgets/view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/theme.dart';
import '../widgets/favorites_card.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  final int userId;
  final int facilityTypeId;

  const FavoritesPage(
      {Key? key, required this.userId, required this.facilityTypeId})
      : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesPage> {
  int selectedType = 0;

  // 0 = الكل، 1 = فنادق، 2 = شاليهات

  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() {
  //     ref.read(facilitiesProvider(FacilityTarget.favorites).notifier).fetch(userId: widget.userId, facilityTypeId: widget.facilityTypeId);
  //   });
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() {
  //     ref.read(favoritesProvider.notifier).fetchFavorites(widget.userId);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = currentUser()?.id;
      if (userId != null) {
        ref.read(favoritesProvider.notifier).fetchFavorites(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);

    print("📌 favoritesState.data: ${favoritesState.data}");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          trans().favorite,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: CustomTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ViewWidget<List<Facility>>(
        meta: favoritesState.meta,
        data: favoritesState.data,
        onLoaded: (data) {
          print("📌 Data Loaded: $data"); // طباعة البيانات عند التحميل

          if (data == null || data.isEmpty) {
            return Center(
              child: Text(
                "لا توجد أماكن مفضلة حالياً",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final facility = data[index];
              print("✅ Rendering: ${facility.name}"); // ✅ طباعة عند عرض العنصر
              return FavoriteCard(facility: facility);
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTypeButton("الكل", 0, Icons.border_all),
          const SizedBox(width: 15),
          _buildTypeButton("فنادق", 1, Icons.hotel),
          const SizedBox(width: 15),
          _buildTypeButton("شاليهات", 2, Icons.pool),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String title, int type, IconData icon) {
    final bool isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => selectedType = type);
      },
      child: Chip(
        label: Text(title),
        avatar: Icon(icon,
            color: isSelected ? Colors.white : CustomTheme.primaryColor),
        backgroundColor:
            isSelected ? CustomTheme.primaryColor : Colors.grey[200],
        labelStyle: TextStyle(
            color: isSelected ? Colors.white : CustomTheme.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
