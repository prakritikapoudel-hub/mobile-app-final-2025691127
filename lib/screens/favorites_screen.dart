
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favorites_storage.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<Meal> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() {
    setState(() {
      favorites = FavoritesStorage.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites ❤️'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh favourites',
            onPressed: loadFavorites,
          ),
        ],
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No favourite recipes yet!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Add recipes you love to see them here.'),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final meal = favorites[index];

                return MealCard(
                  meal: meal,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(meal: meal),
                      ),
                    );

                    if (mounted) {
                      loadFavorites();
                    }
                  },
                );
              },
            ),
    );
  }
}
