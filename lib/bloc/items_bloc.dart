import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/mock_api_service.dart';
import '../services/storage_service.dart';
import 'items_event.dart';
import 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final MockApiService _apiService;
  final StorageService _storageService;

  ItemsBloc({
    required MockApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService,
        super(const ItemsState()) {
    on<LoadItems>(_onLoadItems);
    on<SearchItems>(_onSearchItems);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemsState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final items = await _apiService.getItems();
      emit(state.copyWith(
        items: items,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void _onSearchItems(SearchItems event, Emitter<ItemsState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      await _storageService.toggleFavorite(event.itemId);
      final favoriteIds = await _storageService.getFavoriteIds();
      emit(state.copyWith(favoriteIds: favoriteIds));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<ItemsState> emit,
  ) async {
    try {
      final favoriteIds = await _storageService.getFavoriteIds();
      emit(state.copyWith(favoriteIds: favoriteIds));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
} 