import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onFavoriteToggle;

  const ItemTile({
    super.key,
    required this.item,
    required this.onFavoriteToggle,
  });

  Color _getTagColor(ItemTag tag) {
    switch (tag) {
      case ItemTag.hot:
        return const Color(0xFFFF6B6B); // Coral red
      case ItemTag.new_:
        return const Color(0xFF4CAF50); // Material green
      case ItemTag.old:
        return const Color(0xFF78909C); // Blue grey
    }
  }

  String _getTagText(ItemTag tag) {
    switch (tag) {
      case ItemTag.hot:
        return '🔥 HOT';
      case ItemTag.new_:
        return '✨ NEW';
      case ItemTag.old:
        return '📜 OLD';
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {}, // Could add item detail view later
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getTagColor(item.tag).withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getTagColor(item.tag).withAlpha(125),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getTagText(item.tag),
                          style: TextStyle(
                            color: _getTagColor(item.tag),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        item.isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(item.isFavorite),
                        color: item.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    timeago.format(item.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 