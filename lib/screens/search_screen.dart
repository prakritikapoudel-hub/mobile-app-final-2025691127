
import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/meal_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MealService service = MealService();
  final TextEditingController controller = TextEditingController();

  List<Meal> meals = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> searchMeals() async {
    final query = controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        meals = [];
        errorMessage = 'Please enter a recipe name.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      meals = [];
    });

    try {
      final results = await service.searchMeals(query);

      if (!mounted) return;

      setState(() {
        meals = results;
        if (results.isEmpty) {
          errorMessage = 'No recipes found. Try another name.';
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => searchMeals(),
              decoration: InputDecoration(
                hintText: 'Search for a recipe...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    setState(() {
                      meals = [];
                      errorMessage = null;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : searchMeals,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        )
                      : meals.isEmpty
                          ? const Center(
                              child: Text(
                                'Search your favorite recipes!',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : GridView.builder(
                              itemCount: meals.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                final meal = meals[index];

                                return MealCard(
                                  meal: meal,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MealDetailScreen(meal: meal),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
