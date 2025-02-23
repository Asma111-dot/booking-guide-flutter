import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../storage/favorites_storage.dart';

class FavoritesFacilityProvider extends StateNotifier<List<int>> {
  final FavoritesStorage _storage;

  FavoritesFacilityProvider(this._storage) : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _storage.initialize();
    state = _storage.getFavorites();
  }

  Future<void> toggleFavorite(int itemId) async {
    if (state.contains(itemId)) {
      await _storage.removeFavorite(itemId);
      state = state.where((id) => id != itemId).toList();
    } else {
      await _storage.addFavorite(itemId);
      state = [...state, itemId];
    }
  }

  bool isFavorite(int itemId) => state.contains(itemId);
}

final favoritesProvider = StateNotifierProvider<FavoritesFacilityProvider, List<int>>((ref) {
  return FavoritesFacilityProvider(FavoritesStorage());
});


class FavoritesFacilityTypeNotifier extends StateNotifier<int> {
  FavoritesFacilityTypeNotifier() : super(0);

  void setType(int typeId) {
    state = typeId;
  }

  bool isType(int typeId) => state == typeId;
}

final favoritesFacilityTypeProvider = StateNotifierProvider<FavoritesFacilityTypeNotifier, int>((ref) {
  return FavoritesFacilityTypeNotifier();
});
