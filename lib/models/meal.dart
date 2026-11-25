
class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String instructions;
  final String category;
  final String area;
  final List<String> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.instructions = '',
    this.category = '',
    this.area = '',
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    for (var i = 1; i <= 20; i++) {
      final ingredient =
          (json['strIngredient$i'] ?? '').toString().trim();

      final measure =
          (json['strMeasure$i'] ?? '').toString().trim();

      if (ingredient.isNotEmpty) {
        ingredients.add(
          measure.isEmpty ? ingredient : '$measure $ingredient',
        );
      }
    }

    return Meal(
      id: (json['idMeal'] ?? '').toString(),
      name: (json['strMeal'] ?? 'Untitled recipe').toString(),
      imageUrl: (json['strMealThumb'] ?? '').toString(),
      instructions: (json['strInstructions'] ?? '').toString(),
      category: (json['strCategory'] ?? '').toString(),
      area: (json['strArea'] ?? '').toString(),
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': imageUrl,
      'strInstructions': instructions,
      'strCategory': category,
      'strArea': area,
    };
  }

  factory Meal.fromSavedJson(Map<String, dynamic> json) {
    return Meal.fromJson(json);
  }
}
