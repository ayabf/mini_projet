import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.56.1:3000/photos'));
      if (response.statusCode == 200) {
        setState(() {
          photos = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

Future<void> addPhoto() async {
  try {
    // Replace these values with your new photo data
    var newPhoto = {
      "name": "New Photo",
      "description": "Description of the new photo",
    };

    final response = await http.post(
      Uri.parse('http://192.168.56.1:3000/photos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newPhoto),
    );

    if (response.statusCode == 201) {
      fetchData();
    } else {
      throw Exception('Failed to add photo: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding photo: $e');
  }
}



Future <void> deletePhoto(int index) async {
  try {
    var photoId = photos[index]["idPhoto"];
    print("Deleting photo with ID: $photoId");

    final response = await http.delete(
      Uri.parse('http://192.168.56.1:3000/photos/$photoId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        photos.removeAt(index);
      });
      print('Photo deleted successfully');
    } else {
      print('Failed to delete photo. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting photo: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.photo),
              title: Text('Photo ${index + 1}'),
              subtitle: Text('Description: ${photos[index]["description"]}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhotoDetailsPage(photoDetails: photos[index]),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deletePhoto(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPhoto();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PhotoDetailsPage extends StatelessWidget {
  final Map<String, dynamic> photoDetails;

  PhotoDetailsPage({required this.photoDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Photo Name: ${photoDetails["name"]}'),
            SizedBox(height: 8.0),
            Text('Description: ${photoDetails["description"]}'),
            // Add other photo details here
          ],
        ),
      ),
    );
  }
}
