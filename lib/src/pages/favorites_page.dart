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

  const FavoritesPage({
    Key? key,
    required this.userId,
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          bottom: TabBar(
            indicatorColor: CustomTheme.primaryColor,
            labelColor: CustomTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: trans().all),
              Tab(text: trans().hotel),
              Tab(text: trans().chalet)
            ],
          ),
        ),
        body: ViewWidget<List<Facility>>(
          meta: favoritesState.meta,
          data: favoritesState.data,
          onLoaded: (data) {
            if (data.isEmpty) {
              return Center(
                child: Text(
                  trans().noFavorites,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return TabBarView(
              children: [
                _buildFavoriteList(data, 0), // الكل
                _buildFavoriteList(data, 1), // فنادق
                _buildFavoriteList(data, 2), // شاليهات
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteList(List<Facility> data, int type) {
    final filteredData =
        type == 0 ? data : data.where((f) => f.facilityTypeId == type).toList();

    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final userId = currentUser()?.id;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final facility = filteredData[index];
        return FavoriteWidget(
          facility: facility,
          onRemove: () async {
            if (userId != null) {
              await favoritesNotifier.toggleFavorite(ref, userId, facility);

              final currentList = ref.read(favoritesProvider).data ?? [];
              final updatedList =
                  currentList.where((f) => f.id != facility.id).toList();
              favoritesNotifier.setData(updatedList);
            }
          },
        );
      },
    );
  }
}
