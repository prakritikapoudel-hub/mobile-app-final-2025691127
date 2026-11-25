
class MealCategory {
  final String name;
  final String imageUrl;
  final String description;

  const MealCategory({
    required this.name,
    required this.imageUrl,
    this.description = '',
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      name: json['strCategory']?.toString() ?? '',
      imageUrl: json['strCategoryThumb']?.toString() ?? '',
      description: json['strCategoryDescription']?.toString() ?? '',
    );
  }
}
