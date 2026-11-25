
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favorites_storage.dart';

class MealDetailScreen extends StatefulWidget {
  final Meal meal;

  const MealDetailScreen({
    super.key,
    required this.meal,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final isFavorite = FavoritesStorage.contains(meal.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            tooltip: isFavorite
                ? 'Remove from favourites'
                : 'Add to favourites',
            onPressed: () async {
              await FavoritesStorage.toggle(meal);
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(Icons.restaurant, size: 70),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${meal.category} • ${meal.area}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (meal.ingredients.isEmpty)
                    const Text('No ingredients available.')
                  else
                    ...meal.ingredients.map(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 19,
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 25),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    meal.instructions.isEmpty
                        ? 'No instructions available.'
                        : meal.instructions,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
