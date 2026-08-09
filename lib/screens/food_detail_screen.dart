import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../utilities/app_colors.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, required this.food});

  final FoodItem food;

  double getNutrientValue(String nutrientName) {
    for (var nutrient in food.foodNutrients) {
      if ((nutrient['nutrientName'] ?? '') == nutrientName) {
        return (nutrient['value'] ?? 0).toDouble();
      }
    }
    return 0;
  }

  Widget nutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double calories = getNutrientValue('Energy');
    double protein = getNutrientValue('Protein');
    double fat = getNutrientValue('Total lipid (fat)');
    double carbs = getNutrientValue('Carbohydrate, by difference');

    double calcium = getNutrientValue('Calcium, Ca');
    double iron = getNutrientValue('Iron, Fe');
    double sodium = getNutrientValue('Sodium, Na');
    double vitaminC = getNutrientValue('Vitamin C, total ascorbic acid');
    double vitaminD = getNutrientValue('Vitamin D (D2 + D3), International Units');

    return Scaffold(
      backgroundColor: AppColors.Background,
      appBar: AppBar(
        backgroundColor: AppColors.Primary,
        title: const Text(
          'Nutrition Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  food.description,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  food.brandName.isNotEmpty ? food.brandName : 'USDA Food',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Main Nutrition',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                nutritionRow('Calories', '${calories.toStringAsFixed(0)} kcal'),
                nutritionRow('Protein', '${protein.toStringAsFixed(1)} g'),
                nutritionRow('Fat', '${fat.toStringAsFixed(1)} g'),
                nutritionRow('Carbs', '${carbs.toStringAsFixed(1)} g'),

                const SizedBox(height: 20),
                const Text(
                  'Key Vitamins & Minerals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                nutritionRow('Calcium', '${calcium.toStringAsFixed(1)} mg'),
                nutritionRow('Iron', '${iron.toStringAsFixed(2)} mg'),
                nutritionRow('Sodium', '${sodium.toStringAsFixed(0)} mg'),
                nutritionRow('Vitamin C', '${vitaminC.toStringAsFixed(1)} mg'),
                nutritionRow('Vitamin D', '${vitaminD.toStringAsFixed(0)} IU'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}