import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:3000/categories'));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void editCategory(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryPage(categories[index]),
      ),
    ).then((value) {
      if (value == true) {
        fetchData();
      }
    });
  }

  void viewDetails(int index) {
    print('View Details for Category ${categories[index]["strCategory"]}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsPage(categoryDetails: categories[index]),
      ),
    );
  }

  Future<void> deleteCategory(int index) async {
    try {
      var categoryId = categories[index]["idCategory"];
      final response = await http.delete(
        Uri.parse('http://192.168.56.1:3000/categories/$categoryId'),
      );

      if (response.statusCode == 200) {
        print('Category deleted successfully');
        setState(() {
          categories.removeAt(index);
        });
      } else {
        print('Failed to delete category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  void addCategory() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:3000/categories'),
        body: {
          'strCategory': 'New Category Name',
          'strCategoryDescription': 'Description',
        },
      );

      print('Server Response: ${response.body}');

      if (response.statusCode == 200) {
        print('New category added successfully');
        fetchData();
      } else {
        print('Failed to add new category. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      categories[index]["strCategory"] ?? "N/A",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      categories[index]["strCategoryDescription"] ?? "N/A",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(categories[index]["strCategoryThumb"] ?? ""),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            editCategory(index);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteCategory(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            viewDetails(index);
                          },
                          icon: Icon(Icons.visibility),
                        ),
                      ],
                    ),
                    onTap: () {
                      viewDetails(index);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                addCategory();
              },
              icon: Icon(Icons.add),
              label: Text('Add Category'),
            ),
          ),
        ],
      ),
    );
  }
}

class EditCategoryPage extends StatefulWidget {
  final Map<String, dynamic> category;

  EditCategoryPage(this.category);

  @override
  _EditCategoryPageState createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.category['strCategory'] ?? "";
    descriptionController.text = widget.category['strCategoryDescription'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Category Description'),
            ),
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

  void saveChanges() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.56.1:3000/categories/${widget.category["idCategory"]}'),
        body: {
          'strCategory': nameController.text,
          'strCategoryDescription': descriptionController.text,
        },
      );

      print('Server Response: ${response.body}');

      if (response.statusCode == 200) {
        print('Changes saved successfully');
        Navigator.pop(context, true);
      } else {
        print('Failed to save changes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class CategoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> categoryDetails;

  CategoryDetailsPage({required this.categoryDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${categoryDetails["strCategory"] ?? "N/A"}'),
            SizedBox(height: 8.0),
            Text(
              'Description: ${categoryDetails["strCategoryDescription"] ?? "N/A"}',
            ),
            SizedBox(height: 8.0),
            if (categoryDetails["strCategoryThumb"] != null)
              Image.network(categoryDetails["strCategoryThumb"]),
          ],
        ),
      ),
    );
  }
}
