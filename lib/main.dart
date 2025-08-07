import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'bloc/items_bloc.dart';
import 'bloc/items_event.dart';
import 'bloc/items_state.dart';
import 'models/item.dart';
import 'services/mock_api_service.dart';
import 'services/storage_service.dart';
import 'widgets/item_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Items App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4EFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          surfaceTintColor: Colors.white,
          color: Colors.white
        ),
      ),
      home: BlocProvider(
        create: (context) => ItemsBloc(
          apiService: MockApiService(),
          storageService: StorageService(),
        )..add(const LoadItems())
         ..add(const LoadFavorites()),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Item List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Badge(
                  backgroundColor: theme.colorScheme.primary,
                  label: Text(
                    state.favoriteCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.favorite),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SearchBar(
              hintText: 'Search tasks...',
              leading: const Icon(Icons.search),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (query) {
                context.read<ItemsBloc>().add(SearchItems(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ItemsBloc, ItemsState>(
              builder: (context, state) {
                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error}',
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state.isLoading) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      itemCount: 6,
                      itemBuilder: (context, index) => ItemTile(
                        item: Item(
                          id: 'skeleton_$index',
                          title: 'Loading item title that is quite long to show skeleton',
                          timestamp: DateTime.now(),
                          tag: ItemTag.hot,
                        ),
                        onFavoriteToggle: () {},
                      ),
                    ),
                  );
                }

                final items = state.filteredItems;
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ItemTile(
                      item: item,
                      onFavoriteToggle: () {
                        context.read<ItemsBloc>().add(ToggleFavorite(item.id));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
