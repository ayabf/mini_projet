import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    // Initialize controllers with the current category values
    nameController.text = widget.category['strCategory'];
    descriptionController.text = widget.category['strCategoryDescription'];
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
                // Logic to save changes
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
        Uri.parse(
            'http://192.168.56.1:3000/categories/${widget.category["idCategory"]}'),
        body: {
          'strCategory': nameController.text,
          'strCategoryDescription': descriptionController.text,
        },
      );

      print('Attempting to update category with ID: ${widget.category["idCategory"]}'); // Add this line
      print('Server Response: ${response.body}');

      if (response.statusCode == 200) {
        print('Changes saved successfully');
        Navigator.pop(context, true); // Pass true to indicate successful update
      } else {
        print(
            'Failed to save changes. Status code: ${response.statusCode}');
        // Optionally, show an error message to the user
      }
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error message to the user
    }
  }
}