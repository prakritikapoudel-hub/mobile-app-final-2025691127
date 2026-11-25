
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/meal.dart';

class MealService {
  static const String _base =
      'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> getCategories() async {
    final response = await http.get(
      Uri.parse('$_base/categories.php'),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load categories.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return (data['categories'] as List? ?? [])
        .map((e) => MealCategory.fromJson(e))
        .toList();
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse(
        '$_base/search.php?s=${Uri.encodeQueryComponent(query)}',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not search recipes.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    return (data['meals'] as List? ?? [])
        .map((e) => Meal.fromJson(e))
        .toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        '$_base/filter.php?c=${Uri.encodeQueryComponent(category)}',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load recipes.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final summaries = data['meals'] as List? ?? [];

    final detailed = await Future.wait(
      summaries.map((item) async {
        final id = item['idMeal'].toString();
        return getMealById(id);
      }),
    );

    return detailed.whereType<Meal>().toList();
  }

  Future<Meal?> getMealById(String id) async {
    final response = await http.get(
      Uri.parse('$_base/lookup.php?i=$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load recipe details.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List?;

    if (meals == null || meals.isEmpty) {
      return null;
    }

    return Meal.fromJson(meals.first);
  }
}
