
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';

class FavoritesStorage {
  static SharedPreferences? _prefs;
  static const String _key = 'favorite_meals';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static List<Meal> getFavorites() {
    final raw = _prefs?.get(_key);

    if (raw == null) return [];

    try {
      dynamic decoded;

      if (raw is String) {
        if (raw.isEmpty) return [];
        decoded = jsonDecode(raw);
      } else if (raw is List) {
        decoded = raw;
      } else {
        return [];
      }

      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map(
            (item) => Meal.fromSavedJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveFavorites(List<Meal> meals) async {
    await _prefs?.setString(
      _key,
      jsonEncode(
        meals.map((meal) => meal.toJson()).toList(),
      ),
    );
  }

  static Future<void> toggle(Meal meal) async {
    final items = getFavorites();

    final index = items.indexWhere(
      (item) => item.id == meal.id,
    );

    if (index >= 0) {
      items.removeAt(index);
    } else {
      items.add(meal);
    }

    await saveFavorites(items);
  }

  static bool contains(String id) {
    return getFavorites().any((meal) => meal.id == id);
  }
}
