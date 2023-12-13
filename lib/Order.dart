class Order {
  final String id;
  final String name;
  final String photo;
  final int quantity;

  Order({
    required this.id,
    required this.name,
    required this.photo,
    required this.quantity,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
