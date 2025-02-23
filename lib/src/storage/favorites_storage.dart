import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/hive_service.dart';

const String favoriteBoxKey = 'favorite_items';

class FavoritesStorage {
  late Box<int> _favoritesBox;

  // Singleton pattern for better performance
  static final FavoritesStorage _instance = FavoritesStorage._internal();

  factory FavoritesStorage() => _instance;

  FavoritesStorage._internal();

  // Initialize Hive Box
  Future<void> initialize() async {
    await openBox<int>(favoriteBoxKey);
    _favoritesBox = box<int>(favoriteBoxKey);
  }

  // Get all favorites
  List<int> getFavorites() {
    return _favoritesBox.values.toList();
  }

  // Add favorite
  Future<void> addFavorite(int itemId) async {
    await _favoritesBox.put(itemId, itemId);
  }

  // Remove favorite
  Future<void> removeFavorite(int itemId) async {
    await _favoritesBox.delete(itemId);
  }

  // Check if is favorite
  bool isFavorite(int itemId) {
    return _favoritesBox.containsKey(itemId);
  }
}
