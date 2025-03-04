import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'favorite_provider.g.dart'; // هذا السطر مهم

@Riverpod(keepAlive: false)
class Favorites extends _$Favorites {
  List<int> favoriteIds = []; // قائمة لتخزين معرفات المفضلات

  @override
  Response<List<Facility>> build() => const Response<List<Facility>>(data: []);

  /// جلب قائمة المفضلات
  Future fetchFavorites(int userId) async {
    state = state.setLoading();

    try {
      await request<List<dynamic>>(
        url: getFavoritesUrl(userId),
        method: Method.get,
      ).then((value) {
        favoriteIds = (value.data ?? []).map((e) => e['facility_id'] as int).toList();

        // تحديث الحالة بقائمة المفضلات
        state = state.copyWith(data: state.data, meta: value.meta);
        state = state.setLoaded();
      });
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  /// إضافة منشأة إلى المفضلة
  Future addFavorite(int userId, int facilityId) async {
    try {
      await request<void>(
        url: addFavoriteUrl(userId, facilityId),
        method: Method.post,
      ).then((_) {
        favoriteIds.add(facilityId);

        // تحديث الحالة بإضافة المنشأة إلى المفضلة
        state = state.copyWith(
          data: state.data?.map((facility) {
            if (facility.id == facilityId) {
              return facility.copyWith(isFavorite: true);
            }
            return facility;
          }).toList(),
        );
      });
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  /// إزالة منشأة من المفضلة
  Future removeFavorite(int userId, int facilityId) async {
    try {
      await request<void>(
        url: removeFavoriteUrl(userId, facilityId),
        method: Method.delete,
      ).then((_) {
        favoriteIds.remove(facilityId);

        // تحديث الحالة بإزالة المنشأة من المفضلة
        state = state.copyWith(
          data: state.data?.map((facility) {
            if (facility.id == facilityId) {
              return facility.copyWith(isFavorite: false);
            }
            return facility;
          }).toList(),
        );
      });
    } catch (e) {
      state = state.setError(e.toString());
    }
  }
}