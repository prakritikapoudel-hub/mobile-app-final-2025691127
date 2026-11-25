
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favorites_storage.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    final favorite = FavoritesStorage.contains(widget.meal.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.meal.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: Color(0xFFF1E7DE),
                        child: Icon(Icons.restaurant, size: 48),
                      );
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        tooltip: favorite
                            ? 'Remove from favourites'
                            : 'Add to favourites',
                        icon: Icon(
                          favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorite ? Colors.red : Colors.black87,
                        ),
                        onPressed: () async {
                          await FavoritesStorage.toggle(widget.meal);

                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
