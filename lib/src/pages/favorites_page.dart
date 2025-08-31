import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/general_helper.dart';
import '../models/facility.dart';
import '../providers/favorite/favorite_provider.dart';
import '../storage/auth_storage.dart';
import '../utils/assets.dart';
import '../utils/sizes.dart';
import '../utils/theme.dart';
import '../widgets/facility_shimmer_card.dart';
import '../widgets/view_widget.dart';
import '../widgets/favorites_widget.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  final int userId;

  const FavoritesPage({
    super.key,
    required this.userId,
  });

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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            trans().favorite,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: CustomTheme.color2,
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: TabBar(
            indicatorColor: CustomTheme.color2,
            labelColor: CustomTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle:
                TextStyle(fontSize: TFont.s12, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
              fontSize: TFont.xxs10,
            ),
            tabs: [
              Tab(
                  child: Text(trans().all,
                      textAlign: TextAlign.center, softWrap: true)),
              Tab(
                  child: Text(trans().hotel,
                      textAlign: TextAlign.center, softWrap: true)),
              Tab(
                  child: Text(trans().chalet,
                      textAlign: TextAlign.center, softWrap: true)),
              Tab(
                  child: Text(trans().hall,
                      textAlign: TextAlign.center, softWrap: true)),
            ],
          ),
        ),
        body: ViewWidget<List<Facility>>(
          meta: favoritesState.meta,
          data: favoritesState.data,
          onLoading: () => ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 6,
            itemBuilder: (_, __) => const FacilityShimmerCard(),
          ),
          onLoaded: (data) {
            if (data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      emptyFavoriteIcon,
                      width: S.w(140),
                      height: S.h(140),
                    ),
                    Gaps.h12,
                    Text(
                      trans().noFavorites,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: TFont.xxs10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              children: [
                _buildFavoriteList(data, 0), // الكل
                _buildFavoriteList(data, 1), // فنادق
                _buildFavoriteList(data, 2), // شاليهات
                _buildFavoriteList(data, 3), // قاعة
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
