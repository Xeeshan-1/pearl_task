import 'package:equatable/equatable.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object?> get props => [];
}

class LoadItems extends ItemsEvent {
  const LoadItems();
}

class SearchItems extends ItemsEvent {
  final String query;

  const SearchItems(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavorite extends ItemsEvent {
  final String itemId;

  const ToggleFavorite(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class LoadFavorites extends ItemsEvent {
  const LoadFavorites();
} 