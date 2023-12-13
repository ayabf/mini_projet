import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'EditMealPage.dart';

class MealsPage extends StatefulWidget {
  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.56.1:3000/meals'));
    if (response.statusCode == 200) {
      setState(() {
        meals = List<Map<String, dynamic>>.from(json.decode(response.body) ?? []);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addMeal() async {
    try {
      // Replace these values with your new meal data
      var newMeal = {
        "strMeal": "New Meal",
        "idCategory": "1",
        "strArea": "Area",
        "price": 10.0,
        "strMealThumb": "https://www.example.com/newmeal.jpg",
      };

      final response = await http.post(
        Uri.parse('http://192.168.56.1:3000/meals'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newMeal),
      );

      if (response.statusCode == 201) {
        setState(() {
          meals.add(newMeal);
        });
      } else {
        throw Exception('Failed to add meal');
      }
    } catch (e) {
      print('Error adding meal: $e');
    }
  }

  Future<void> updateMeal(int index) async {
    try {
      // Replace these values with your updated meal data
      var updatedMeal = {
        "strMeal": "Updated Meal",
        "idCategory": "2",
        "strArea": "Updated Area",
        "price": 15.0,
        "strMealThumb": "https://www.example.com/updatedmeal.jpg",
      };

      final response = await http.put(
        Uri.parse('http://192.168.56.1:3000/meals/${meals[index]["id"] ?? ""}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedMeal),
      );

      if (response.statusCode == 200) {
        setState(() {
          meals[index] = updatedMeal;
        });
      } else {
        throw Exception('Failed to update meal');
      }
    } catch (e) {
      print('Error updating meal: $e');
    }
  }

  Future<void> deleteMeal(int index) async {
    try {
      var mealId = meals[index]["id"];

      final response = await http.delete(
        Uri.parse('http://192.168.56.1:3000/meals/$mealId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          meals.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete meal');
      }
    } catch (e) {
      print('Error deleting meal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Meals'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addMeal();
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(meals[index]["strMeal"] ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${meals[index]["idCategory"] ?? ""}'),
                  Text('Area: ${meals[index]["strArea"] ?? ""}'),
                  Text('Price: ${meals[index]["price"] ?? ""}'),
                ],
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(meals[index]["strMealThumb"] ?? ""),
              ),
              onTap: () {
                showMealDetails(index);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      editMeal(index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteMeal(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void editMeal(int index) {
    Map<String, dynamic> mealDetails = meals[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMealPage(mealDetails: mealDetails),
      ),
    );
  }

  void showMealDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailsPage(mealDetails: meals[index]),
      ),
    );
  }
}

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
            Text('Meal Name: ${mealDetails["strMeal"] ?? ""}'),
            SizedBox(height: 8.0),
            Text('Category: ${mealDetails["idCategory"] ?? ""}'),
            SizedBox(height: 8.0),
            Text('Area: ${mealDetails["strArea"] ?? ""}'),
            SizedBox(height: 8.0),
            Text('Price: ${mealDetails["price"] ?? ""}'),
            SizedBox(height: 8.0),
            if (mealDetails["strMealThumb"] != null)
              Image.network(mealDetails["strMealThumb"]),
          ],
        ),
      ),
    );
  }
}
