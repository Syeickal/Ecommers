import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id; // Document ID dari item di keranjang
  final String productId; // ID dari produk di koleksi 'products'
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  // Konversi dari Firestore Document ke objek CartItem
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      name: data['name'] ?? 'No Name',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      quantity: data['quantity'] ?? 0,
    );
  }

  // Konversi dari objek CartItem ke Map untuk disimpan di Firestore
  Map<String, dynamic> toOrderMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,

    };
  }
}