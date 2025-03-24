import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/facility.dart';
import '../../models/response/response.dart';
import '../../services/request_service.dart';
import '../../utils/urls.dart';

part 'favorite_provider.g.dart';

@Riverpod(keepAlive: true)
class Favorites extends _$Favorites {
  @override
  Response<List<Facility>> build() {
    return const Response<List<Facility>>(data: []);
  }

  Future<void> fetchFavorites(int userId) async {
    state = state.setLoading();
    String url = getFavoritesUrl(userId: userId);
    print("📢 Fetching favorites from URL: $url");

    try {
      final response = await request<Map<String, dynamic>>(
        url: url,
        method: Method.get,
      );

      print("📌 Raw API Response: ${response.data}"); // ✅ طباعة استجابة API كاملة

      if (response.data == null) {
        print("⚠ API response is null!");
        state = state.copyWith(data: [], meta: response.meta);
        state = state.setLoaded();
        return;
      }

      if (!response.data!.containsKey('favorites')) {
        print("⚠ Missing 'favorites' key in API response");
        state = state.copyWith(data: [], meta: response.meta);
        state = state.setLoaded();
        return;
      }

      // ✅ استخراج جميع المفضلات بدون فلترة
      List<dynamic> favoriteList = response.data!['favorites'] ?? [];
      print("📌 Raw Favorites List: $favoriteList"); // ✅ طباعة البيانات الأولية

      List<Facility> facilities = favoriteList
          .map((e) {
        try {
          return Facility.fromJson(e as Map<String, dynamic>);
        } catch (error) {
          print("❌ Error parsing facility: $e");
          return null;
        }
      })
          .whereType<Facility>()
          .toList();

      print("✅ Parsed Favorites: ${facilities.length} items"); // ✅ طباعة عدد العناصر بعد التحويل

      state = state.copyWith(data: facilities, meta: response.meta);
      state = state.setLoaded();
    } catch (e, stackTrace) {
      print("❌ Error fetching favorites: $e");
      print(stackTrace);
      state = state.setError("Failed to fetch favorites: $e");
    }
  }


    /// ✅ **إضافة / حذف منشأة من المفضلة عبر API ثم إعادة تحميل المفضلات**
    // Future<void> toggleFavorite(WidgetRef ref, int userId, Facility facility) async {
    //   final bool isFav = state.data?.any((f) => f.id == facility.id) ?? false;
    //   final String url = isFav
    //       ? removeFavoriteUrl(userId, facility.id)
    //       : addFavoriteUrl(userId, facility.id);
    //
    //   try {
    //     await request<void>(
    //       url: url,
    //       method: isFav ? Method.delete : Method.post,
    //     );
    //
    //     // ✅ تحديث `state` محليًا بدون جلب جديد من API
    //     List<Facility> updatedFavorites = List.from(state.data ?? []);
    //
    //     if (isFav) {
    //       updatedFavorites.removeWhere((f) => f.id == facility.id);
    //     } else {
    //       updatedFavorites.add(facility);
    //     }
    //
    //     state = state.copyWith(data: updatedFavorites);
    //   } catch (e) {
    //     state = state.setError(e.toString());
    //   }
    // }
    Future<void> toggleFavorite(WidgetRef ref, int userId,
        Facility facility) async {
      final bool isFav = state.data?.any((f) => f.id == facility.id) ?? false;
      final String url = isFav
          ? removeFavoriteUrl(userId, facility.id)
          : addFavoriteUrl(userId, facility.id);

      // ✅ تحديث القائمة محليًا لتحديث الواجهة فورًا
      List<Facility> updatedFavorites = List.from(state.data ?? []);

      if (isFav) {
        updatedFavorites.removeWhere((f) => f.id == facility.id);
      } else {
        updatedFavorites.add(facility.copyWith(isFavorite: true));
      }

      state = state.copyWith(data: updatedFavorites);

      try {
        await request<void>(
          url: url,
          method: isFav ? Method.delete : Method.post,
        );
      } catch (e) {
        // ✅ في حالة الفشل، نعيد الحالة القديمة
        state = state.copyWith(
            data: isFav ? [...state.data ?? [], facility] : updatedFavorites);
        state = state.setError(e.toString());
      }
    }

    /// ✅ **التحقق إذا كانت المنشأة مفضلة**
    bool isFavorite(int facilityId) {
      return state.data?.any((facility) => facility.id == facilityId) ?? false;
    }

    /// ✅ **جلب قائمة المفضلات**
    // List<Facility> get favoriteFacilities => state.data ?? [];
  }
