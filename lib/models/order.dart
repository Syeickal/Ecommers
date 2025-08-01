import 'package:cloud_firestore/cloud_firestore.dart'; // <-- PERBAIKAN DI SINI

class Order {
  final String orderId;
  final String userId;
  final double totalPrice;
  final String status;
  final Timestamp createdAt;
  final String shippingAddress;
  final String paymentMethod;
  final List<dynamic> items;

  Order({
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.items,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Order(
      orderId: data['orderId'] ?? '',
      userId: data['userId'] ?? '',
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Unknown',
      // Logika ini untuk menangani data lama yang mungkin tidak punya timestamp
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt']
          : Timestamp.now(),
      shippingAddress: data['shippingAddress'] ?? 'No Address',
      paymentMethod: data['paymentMethod'] ?? 'Not Set',
      items: data['items'] ?? [],
    );
  }
}