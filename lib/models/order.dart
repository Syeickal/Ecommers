import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? 'No Name',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }
}

class Order {
  final String id;
  final double totalPrice;
  final Timestamp timestamp;
  final String status;
  final String paymentMethod; // <-- TAMBAHKAN BARIS INI
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.totalPrice,
    required this.timestamp,
    required this.status,
    required this.paymentMethod, // <-- TAMBAHKAN BARIS INI
    required this.items,
  });

  static Future<Order> fromFirestore(DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    QuerySnapshot itemsSnapshot = await doc.reference.collection('items').get();
    List<OrderItem> orderItems = itemsSnapshot.docs
        .map((itemDoc) =>
        OrderItem.fromMap(itemDoc.data() as Map<String, dynamic>))
        .toList();

    return Order(
      id: doc.id,
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: data['status'] ?? 'Unknown',
      paymentMethod: data['paymentMethod'] ?? 'N/A', // <-- TAMBAHKAN BARIS INI
      items: orderItems,
    );
  }
}