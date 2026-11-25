
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatefulWidget {
  final String category;

  const MealListScreen({
    super.key,
    required this.category,
  });

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealService service = MealService();
  late Future<List<Meal>> meals;

  @override
  void initState() {
    super.initState();
    meals = service.getMealsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<List<Meal>>(
        future: meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Could not load recipes. Please try again.'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text('No recipes found in this category.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final meal = items[index];

              return MealCard(
                meal: meal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(meal: meal),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
