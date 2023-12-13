import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.56.1:3000/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addOrder() async {
    try {
      var newOrder = {
        "id": "53123",
        "name": "New Item",
        "photo": "https://www.example.com/newitem.jpg",
        "quantity": 1,
      };

      final response = await http.post(
        Uri.parse('http://192.168.56.1:3000/orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newOrder),
      );

      if (response.statusCode == 201) {
        setState(() {
          orders.add(newOrder);
        });
      } else {
        throw Exception('Failed to add order');
      }
    } catch (e) {
      print('Error adding order: $e');
      // Handle errors here
      rethrow;
    }
  }

  Future<void> updateOrder(int index) async {
    try {
      var updatedOrder = {
        "id": "53028",
        "name": "Updated Item",
        "photo": "https://www.example.com/updateditem.jpg",
        "quantity": 2,
      };

      final response = await http.put(
        Uri.parse('http://192.168.56.1:3000/orders/${updatedOrder["id"]}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedOrder),
      );

      if (response.statusCode == 200) {
        setState(() {
          orders[index] = updatedOrder;
        });
      } else {
        throw Exception('Failed to update order');
      }
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  Future<void> deleteOrder(int index) async {
    try {
      var orderId = orders[index]["id"].toString();
      final response = await http.delete(
        Uri.parse('http://192.168.56.1:3000/orders/$orderId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          orders.removeAt(index);
        });
      } else {
        throw Exception('Failed to delete order');
      }
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  void viewDetails(int index) {
    print('View Details for Order ${orders[index]["id"]}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderDetails: orders[index]),
      ),
    );
  }

  // Fonction de gestion pour l'ajout d'une commande
  void handleAddClick() {
    addOrder();
  }

  // Fonction de gestion pour l'édition d'une commande
  void handleEditClick(int index) {
    updateOrder(index);
  }

  // Fonction de gestion pour la suppression d'une commande
  void handleDeleteClick(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer cette commande ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                // Appeler la fonction de gestion pour la suppression
                deleteOrder(index);
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleAddClick,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, orderIndex) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order ${orderIndex + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Appeler la fonction de gestion pour l'édition
                          handleEditClick(orderIndex);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Appeler la fonction de gestion pour la suppression
                          handleDeleteClick(orderIndex);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.details),
                        onPressed: () {
                          viewDetails(orderIndex);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderDetails;

  OrderDetailsPage({required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${orderDetails["id"]}'),
            SizedBox(height: 8.0),
            Text('Name: ${orderDetails["name"]}'),
            SizedBox(height: 8.0),
            Text('Photo: ${orderDetails["photo"]}'),
            SizedBox(height: 8.0),
            Text('Quantity: ${orderDetails["quantity"]}'),
          ],
        ),
      ),
    );
  }
}
