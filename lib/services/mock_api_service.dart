import 'dart:math';
import 'package:dio/dio.dart';
import '../models/item.dart';

class MockApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://dummyjson.com';

  static const int _newItemThresholdDays = 3;
  static const int _hotItemThresholdDays = 7;
  static const int _hotItemMinViews = 100;

  Future<List<Item>> getItems() async {
    try {
      final response = await _dio.get('$_baseUrl/todos');
      final data = response.data;
      final todos = data['todos'] as List;
      final now = DateTime.now();

      return todos.map<Item>((todo) {
        final views = todo['userId'] * 20;
        final daysAgo = Random().nextInt(_hotItemThresholdDays * 2);
        final timestamp = now.subtract(Duration(days: daysAgo));

        final ItemTag tag;
        if (daysAgo <= _newItemThresholdDays) {
          tag = ItemTag.new_;
        } else if (daysAgo <= _hotItemThresholdDays && views >= _hotItemMinViews) {
          tag = ItemTag.hot;
        } else {
          tag = ItemTag.old;
        }

        return Item(
          id: todo['id'].toString(),
          title: todo['todo'],
          timestamp: timestamp,
          tag: tag,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch items');
    }
  }
} 