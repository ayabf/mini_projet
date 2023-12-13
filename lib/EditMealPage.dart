import 'package:flutter/material.dart';

class EditMealPage extends StatefulWidget {
  final Map<String, dynamic> mealDetails;

  EditMealPage({required this.mealDetails});

  @override
  _EditMealPageState createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController areaController;
  late TextEditingController priceController;
  late TextEditingController thumbController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.mealDetails["strMeal"]);
    categoryController =
        TextEditingController(text: widget.mealDetails["idCategory"]);
    areaController = TextEditingController(text: widget.mealDetails["strArea"]);
    priceController = TextEditingController(text: widget.mealDetails["price"].toString());
    thumbController =
        TextEditingController(text: widget.mealDetails["strMealThumb"]);
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    areaController.dispose();
    priceController.dispose();
    thumbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Meal Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: areaController,
              decoration: InputDecoration(labelText: 'Area'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: thumbController,
              decoration: InputDecoration(labelText: 'Thumbnail URL'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges() {
    // Implement logic to save changes to the backend or update the state
    // You can use the TextEditingController values to get the updated values
    // and then perform the necessary actions (e.g., API calls, database updates).

    // After saving changes, you can navigate back to the previous screen.
    Navigator.pop(context);
  }
}
