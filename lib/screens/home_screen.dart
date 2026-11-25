
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../services/meal_service.dart';
import 'meal_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealService service = MealService();

  late Future<List<MealCategory>> categories;

  @override
  void initState() {
    super.initState();
    categories = service.getCategories();
  }

  Future<void> refreshCategories() async {
    setState(() {
      categories = service.getCategories();
    });
  }

  void showAboutDialogBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'About Me',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFFFE6D5),
                backgroundImage: AssetImage(
                  'assets/profile_photo.jpg',
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Paudel Prakriti',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Student ID: 2025691127'),
              const SizedBox(height: 12),
              const Text(
                'Recipe Explorer App',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe Explorer 🍽️',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: showAboutDialogBox,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshCategories,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE6D5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover Delicious Recipes!',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D351D),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Explore different cuisines and find your next favorite meal.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Explore Categories',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<MealCategory>>(
                  future: categories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(35),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            const Text('Could not load categories.'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: refreshCategories,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    final items = snapshot.data ?? [];

                    if (items.isEmpty) {
                      return const Center(
                        child: Text('No categories found.'),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final category = items[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MealListScreen(
                                  category: category.name,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    category.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.restaurant,
                                        size: 55,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
