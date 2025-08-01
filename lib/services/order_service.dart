import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- PERUBAHAN DI SINI ---
  Future<void> createOrder({
    required List<CartItem> cartItems,
    required double totalPrice,
    required String shippingAddress,
    required String paymentMethod, // <-- Tambahkan parameter ini
  }) async {
    // --- AKHIR PERUBAHAN ---
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Anda harus login untuk membuat pesanan.");
    }

    final orderRef = _firestore.collection('orders').doc();

    final itemsAsMaps = cartItems.map((item) => item.toOrderMap()).toList();

    await orderRef.set({
      'userId': user.uid,
      'userEmail': user.email,
      'orderId': orderRef.id,
      'createdAt': Timestamp.now(),
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'status': 'Pending',
      'items': itemsAsMaps,
      'paymentMethod': paymentMethod, // <-- Simpan datanya di sini
    });

    final cartCollection = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    final cartSnapshot = await cartCollection.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<Order>> getOrdersStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
    });
  }
}