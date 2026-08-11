import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../utilities/api_calls.dart';
import '../utilities/app_colors.dart';
import 'food_detail_screen.dart';
import '../widgets/navigation_bar.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  TextEditingController searchController = TextEditingController();
  Future<List<FoodItem>>? foodResults;

  void runSearch() {
    if (searchController.text.trim().isEmpty) return;
    setState(() {
      foodResults = ApiCalls().searchFoods(searchController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Food Search',
          style: TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search food (e.g. salmon)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => runSearch(), //'_' suggested by Claude AI as data returned by runSearch() is not used
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: runSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(55, 55),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: foodResults == null
                  ? const Center(child: Text('Search to view foods'))
                  : FutureBuilder<List<FoodItem>>(
                future: foodResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: AppColors.error)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No foods found'));
                  }

                  List<FoodItem> foods = snapshot.data!;
                  return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      FoodItem food = foods[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            food.description,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            food.brandName.isNotEmpty
                                ? food.brandName
                                : (food.foodCategory.isNotEmpty ? food.foodCategory : 'USDA Food'),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailScreen(food: food),
                              ),
                            );
                          },
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