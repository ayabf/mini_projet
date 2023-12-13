import 'package:flutter/material.dart';

class MealDetailsPage extends StatelessWidget {
  final Map<String, dynamic> mealDetails;

  MealDetailsPage({required this.mealDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meal Name: ${mealDetails["strMeal"] ?? "N/A"}'),
            SizedBox(height: 8.0),
            Text('Category: ${mealDetails["idCategory"] ?? "N/A"}'),
            SizedBox(height: 8.0),
            Text('Area: ${mealDetails["strArea"] ?? "N/A"}'),
            SizedBox(height: 8.0),
            Text('Price: ${mealDetails["price"]?.toString() ?? "N/A"}'),
            SizedBox(height: 8.0),
            mealDetails["strMealThumb"] != null
                ? Image.network(mealDetails["strMealThumb"])
                : Container(), // You can customize this part based on your app's UI
            // Add other meal details here
          ],
        ),
      ),
    );
  }
}
