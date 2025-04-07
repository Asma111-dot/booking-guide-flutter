import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/theme.dart';
import '../widgets/view_widget.dart';
import '../widgets/favorites_widget.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  final int userId;
  final int facilityTypeId;

  const FavoritesPage({
    Key? key,
    required this.userId,
    required this.facilityTypeId,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesPage> {
  int selectedType = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = currentUser()?.id;
      if (userId != null) {
        ref.read(favoritesProvider.notifier).fetchFavorites(userId: userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final userId = currentUser()?.id;

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
          if (data == null || data.isEmpty) {
            return Center(
              child: Text(
                trans().noFavorites,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final filteredData = selectedType == 0
              ? data
              : data.where((f) => f.facilityTypeId == selectedType).toList();

          return Column(
            children: [
              const SizedBox(height: 8),
              _buildFilterButtons(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final facility = filteredData[index];
                    return FavoriteWidget(
                      facility: facility,
                      onRemove: () async {
                        if (userId != null) {
                          await favoritesNotifier.toggleFavorite(ref, userId, facility);

                          final currentList = favoritesState.data ?? [];
                          final updatedList = currentList.where((f) => f.id != facility.id).toList();
                          favoritesNotifier.setData(updatedList);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
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
