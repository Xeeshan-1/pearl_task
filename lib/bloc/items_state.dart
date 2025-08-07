import 'package:equatable/equatable.dart';
import '../models/item.dart';

class ItemsState extends Equatable {
  final List<Item> items;
  final bool isLoading;
  final String searchQuery;
  final String? error;
  final Set<String> favoriteIds;

  const ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.error,
    this.favoriteIds = const {},
  });

  List<Item> get filteredItems {
    return items.map((item) {
      return item.copyWith(isFavorite: favoriteIds.contains(item.id));
    }).where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  int get favoriteCount => favoriteIds.length;

  ItemsState copyWith({
    List<Item>? items,
    bool? isLoading,
    String? searchQuery,
    String? error,
    Set<String>? favoriteIds,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [items, isLoading, searchQuery, error, favoriteIds];
} 