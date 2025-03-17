import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'favorite_provider.g.dart';

@Riverpod(keepAlive: false)
class Favorites extends _$Favorites {
  List<int> favoriteIds = [];

  @override
  Response<List<Facility>> build() => const Response<List<Facility>>(data: []);

  Future<void> fetchFavorites(int userId) async {
    state = state.setLoading();

    try {
      final response = await request<Map<String, dynamic>>(
        url: getFavoritesUrl(userId),
        method: Method.get,
      );

      final favoritesData = response.data?['favorites'] as List<dynamic>? ?? [];

      favoriteIds = favoritesData.map((e) => e['id'] as int).toList();

      List<Facility> facilities =
      favoritesData.map((e) => Facility.fromJson(e)).toList();

      state = state.copyWith(data: facilities, meta: response.meta);
      state = state.setLoaded();
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  Future<void> addFavorite(WidgetRef ref, int userId, int facilityId) async {
    try {
      await request<void>(
        url: addFavoriteUrl(userId, facilityId),
        method: Method.post,
      );

      // تحديث القائمة الحالية
      final updatedFacilities = [
        ...?state.data,
        Facility(
          id: facilityId,
          name: 'منشأة غير معروفة',
          desc: 'وصف غير متوفر',
          status: 'متاح',
          facilityTypeId: 1,
          isFavorite: true,
        ),
      ];

      // تحديث المفضلات
      favoriteIds.add(facilityId);

      // تحديث حالة Riverpod
      state = state.copyWith(data: updatedFacilities);

      // إعادة بناء UI
      ref.invalidate(favoritesProvider);
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  Future<void> removeFavorite(WidgetRef ref, int userId, int facilityId) async {
    try {
      await request<void>(
        url: removeFavoriteUrl(userId, facilityId),
        method: Method.delete,
      );

      final updatedFacilities =
      state.data?.where((facility) => facility.id != facilityId).toList();

      favoriteIds.remove(facilityId);

      state = state.copyWith(data: updatedFacilities);

      ref.invalidate(favoritesProvider);
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  Future<void> clearFavorites(WidgetRef ref, int userId) async {
    try {
      await request<void>(
        url: clearFavoritesUrl(userId),
        method: Method.delete,
      );

      favoriteIds.clear();

      state = state.copyWith(data: []);

      ref.invalidate(favoritesProvider);
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  bool isFavorite(int facilityId) {
    return favoriteIds.contains(facilityId);
  }
}
