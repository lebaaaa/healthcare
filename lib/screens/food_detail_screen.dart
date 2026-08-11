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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Main Nutrition',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                NutritionRow(label: 'Calories', value: '${calories.toStringAsFixed(0)} kcal'),
                NutritionRow(label: 'Protein', value: '${protein.toStringAsFixed(1)} g'),
                NutritionRow(label: 'Fat', value: '${fat.toStringAsFixed(1)} g'),
                NutritionRow(label: 'Carbs', value: '${carbs.toStringAsFixed(1)} g'),

                const SizedBox(height: 20),
                const Text(
                  'Key Vitamins & Minerals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                NutritionRow(label: 'Calcium', value: '${calcium.toStringAsFixed(1)} mg'),
                NutritionRow(label: 'Iron', value: '${iron.toStringAsFixed(2)} mg'),
                NutritionRow(label: 'Sodium', value: '${sodium.toStringAsFixed(0)} mg'),
                NutritionRow(label: 'Vitamin C', value: '${vitaminC.toStringAsFixed(1)} mg'),
                NutritionRow(label: 'Vitamin D', value: '${vitaminD.toStringAsFixed(0)} IU'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NutritionRow extends StatelessWidget {
  const NutritionRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
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
}