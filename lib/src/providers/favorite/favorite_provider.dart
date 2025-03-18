import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'favorite_provider.g.dart';

@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  final Set<int> favoriteIds = {};

  @override
  Response<List<Facility>> build() {
    _loadFavorites(); // تحميل المفضلات عند تشغيل التطبيق
    return const Response<List<Facility>>(data: []);
  }

  /// 🛠️ **تحميل المفضلات المحفوظة من التخزين المحلي**
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedFavorites = prefs.getStringList('favorite_ids');

    if (savedFavorites != null) {
      favoriteIds.clear();
      favoriteIds.addAll(savedFavorites.map(int.parse));
    }
  }

  /// 🛠️ **حفظ المفضلات في التخزين المحلي**
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_ids', favoriteIds.map((e) => e.toString()).toList());
  }

  /// ✅ **جلب المفضلات من API**
  Future<void> fetchFavorites(int userId) async {
    state = state.setLoading();
    try {
      final response = await request<Map<String, dynamic>>(
        url: getFavoritesUrl(userId),
        method: Method.get,
      );

      final favoritesData = response.data?['favorites'] as List<dynamic>? ?? [];
      favoriteIds.clear();
      favoriteIds.addAll(favoritesData.map((e) => e['id'] as int));

      List<Facility> facilities = favoritesData.map((e) => Facility.fromJson(e)).toList();

      state = state.copyWith(data: facilities, meta: response.meta);
      state = state.setLoaded();

      await _saveFavorites(); // حفظ المفضلات بعد جلبها
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  /// ✅ **إضافة / حذف منشأة من المفضلة**
  Future<void> toggleFavorite(WidgetRef ref, int userId, Facility facility) async {
    final isFav = favoriteIds.contains(facility.id);
    final String url = isFav
        ? removeFavoriteUrl(userId, facility.id)
        : addFavoriteUrl(userId, facility.id);

    try {
      await request<void>(
        url: url,
        method: isFav ? Method.delete : Method.post,
      );

      if (isFav) {
        favoriteIds.remove(facility.id);
      } else {
        favoriteIds.add(facility.id);
      }

      await _saveFavorites(); // حفظ المفضلات محليًا

      // ✅ تحديث الحالة لضمان إعادة بناء الواجهة
      state = state.copyWith(
          data: [
            ...favoriteIds.map((id) => Facility(
              id: id,
              name: 'Unknown Facility',
              status: 'active',
              facilityTypeId: 0,
              desc: 'No description available',
            )).toList()
          ]
      );
    } catch (e) {
      state = state.setError(e.toString());
    }
  }

  /// ✅ **التحقق إذا كانت المنشأة مفضلة**
  bool isFavorite(int facilityId) {
    return favoriteIds.contains(facilityId);
  }

  /// ✅ **جلب قائمة المفضلات**
  List<Facility> get favoriteFacilities =>
      state.data?.where((facility) => favoriteIds.contains(facility.id)).toList() ?? [];
}
