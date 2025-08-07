import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';

class StorageService {
  static const String _itemsKey = 'items';
  static const String _favoritesKey = 'favorites';
  
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Set<String>> getFavoriteIds() async {
    final favorites = _prefs.getStringList(_favoritesKey) ?? [];
    return favorites.toSet();
  }

  Future<void> toggleFavorite(String itemId) async {
    final favorites = await getFavoriteIds();
    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }
    await _prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> saveItems(List<Item> items) async {
    final itemsJson = items.map((item) => item.toJson()).toList();
    await _prefs.setString(_itemsKey, jsonEncode(itemsJson));
  }

  Future<List<Item>> getItems() async {
    final itemsString = _prefs.getString(_itemsKey);
    if (itemsString == null) return [];

    try {
      final itemsJson = jsonDecode(itemsString) as List;
      return itemsJson.map((json) => Item.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearItems() async {
    await _prefs.remove(_itemsKey);
  }

  Future<void> addItem(Item item) async {
    final items = await getItems();
    items.add(item);
    await saveItems(items);
  }

  Future<void> removeItem(String id) async {
    final items = await getItems();
    items.removeWhere((item) => item.id == id);
    await saveItems(items);
  }

  Future<void> updateItem(Item updatedItem) async {
    final items = await getItems();
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      await saveItems(items);
    }
  }
} 