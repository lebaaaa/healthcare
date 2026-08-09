class FoodItem {
  int fdcId;
  String description;
  String brandName;
  String foodCategory;
  List<dynamic> foodNutrients;

  FoodItem({
    required this.fdcId,
    required this.description,
    required this.brandName,
    required this.foodCategory,
    required this.foodNutrients,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      fdcId: json['fdcId'] ?? 0,
      description: json['description'] ?? 'No name',
      brandName: json['brandName'] ?? '',
      foodCategory: json['foodCategory'] ?? '',
      foodNutrients: json['foodNutrients'] ?? [],
    );
  }
}