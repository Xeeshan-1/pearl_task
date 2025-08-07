import 'package:equatable/equatable.dart';

enum ItemTag { hot, new_, old }

class Item extends Equatable {
  final String id;
  final String title;
  final bool isFavorite;
  final DateTime timestamp;
  final ItemTag tag;

  const Item({
    required this.id,
    required this.title,
    this.isFavorite = false,
    required this.timestamp,
    required this.tag,
  });

  Item copyWith({
    String? id,
    String? title,
    bool? isFavorite,
    DateTime? timestamp,
    ItemTag? tag,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      isFavorite: isFavorite ?? this.isFavorite,
      timestamp: timestamp ?? this.timestamp,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isFavorite': isFavorite,
      'timestamp': timestamp.toIso8601String(),
      'tag': tag.name,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      isFavorite: json['isFavorite'] ?? false,
      timestamp: DateTime.parse(json['timestamp']),
      tag: ItemTag.values.firstWhere(
        (e) => e.name == json['tag'],
        orElse: () => ItemTag.new_,
      ),
    );
  }

  @override
  List<Object?> get props => [id, title, isFavorite, timestamp, tag];
} 