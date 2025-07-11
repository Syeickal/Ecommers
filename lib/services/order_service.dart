import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _ordersCollection => _firestore
      .collection('users')
      .doc(_auth.currentUser?.uid)
      .collection('orders');

  Future<void> createOrder(
      List<CartItem> cartItems, String paymentMethod) async {
    if (_auth.currentUser?.uid == null) {
      throw Exception("Pengguna tidak login.");
    }
    if (cartItems.isEmpty) {
      throw Exception("Keranjang kosong.");
    }

    final WriteBatch batch = _firestore.batch();
    final DocumentReference orderRef = _ordersCollection.doc();
    final double totalPrice =
    cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    batch.set(orderRef, {
      'totalPrice': totalPrice,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Pesanan Diterima',
      'paymentMethod': paymentMethod,
    });

    for (var item in cartItems) {
      final DocumentReference itemRef =
      orderRef.collection('items').doc(item.productId);
      batch.set(itemRef, item.toJson());
    }

    await batch.commit();
  }

  // PASTIKAN FUNGSI INI ADA DI DALAM FILE ANDA
  Stream<List<Order>> getOrdersStream() {
    if (_auth.currentUser?.uid == null) {
      return Stream.value([]);
    }

    return _ordersCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Kita perlu memproses setiap dokumen untuk mengambil sub-koleksi item-nya
      final orders = await Future.wait(snapshot.docs.map((doc) {
        return Order.fromFirestore(doc);
      }).toList());
      return orders;
    });
  }
}