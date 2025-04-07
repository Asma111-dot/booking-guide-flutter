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
  Response<List<Facility>> build() => const Response<List<Facility>>(data: []);

  void setData(List<Facility> newData) {
    state = state.copyWith(data: newData);
  }

  Future fetchFavorites({required int userId}) async {
    state = state.setLoading();
    String url = getFavoritesUrl(userId: userId);

    try {
      final response = await request<List<dynamic>>(
        url: url,
        method: Method.get,
      );

      if (response.data == null) {
        state = state.copyWith(data: [], meta: response.meta);
        state = state.setLoaded();
        return;
      }

      final facilities =
          response.data!.map((item) => Facility.fromJson(item)).toList();

      state = state.copyWith(data: facilities, meta: response.meta);
      state = state.setLoaded();
    } catch (e, stackTrace) {
      print("❌ Error fetching favorites: $e");
      print(stackTrace);
      state = state.setError("فشل في تحميل المفضلة: $e");
    }
  }

  Future<void> toggleFavorite(
      WidgetRef ref, int userId, Facility facility) async {
    final bool isFav = state.data?.any((f) => f.id == facility.id) ?? false;
    final String url = isFav
        ? removeFavoriteUrl(userId, facility.id)
        : addFavoriteUrl(userId, facility.id);

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
      state = state.copyWith(
          data: isFav ? [...state.data ?? [], facility] : updatedFavorites);
      state = state.setError(e.toString());
    }
  }

  bool isFavorite(int facilityId) {
    return state.data?.any((facility) => facility.id == facilityId) ?? false;
  }
}
