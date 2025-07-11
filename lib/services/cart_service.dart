import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan UID pengguna yang sedang login
  String? get _uid => _auth.currentUser?.uid;

  // Mendapatkan koleksi keranjang untuk pengguna saat ini
  CollectionReference get _cartCollection =>
      _firestore.collection('users').doc(_uid).collection('cart');

  // Menambah produk ke keranjang
  Future<void> addToCart(Product product) async {
    if (_uid == null) throw Exception("Pengguna belum login");

    final cartRef = _cartCollection;
    final query = await cartRef.where('productId', isEqualTo: product.id).get();

    if (query.docs.isNotEmpty) {
      // Jika produk sudah ada, tambahkan kuantitasnya
      final doc = query.docs.first;
      await cartRef.doc(doc.id).update({'quantity': doc['quantity'] + 1});
    } else {
      // Jika produk belum ada, tambahkan sebagai item baru
      await cartRef.add({
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'quantity': 1,
      });
    }
  }

  // Mendapatkan stream dari keranjang untuk update real-time
  Stream<QuerySnapshot> getCartStream() {
    if (_uid == null) return Stream.empty();
    return _cartCollection.snapshots();
  }

  // Menghapus item dari keranjang
  Future<void> removeFromCart(String cartItemId) async {
    if (_uid == null) throw Exception("Pengguna belum login");
    await _cartCollection.doc(cartItemId).delete();
  }

  // Mengosongkan keranjang setelah checkout
  Future<void> clearCart() async {
    if (_uid == null) throw Exception("Pengguna belum login");
    final snapshot = await _cartCollection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Memperbarui kuantitas item
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    if (_uid == null) throw Exception("Pengguna belum login");
    if (newQuantity > 0) {
      await _cartCollection.doc(cartItemId).update({'quantity': newQuantity});
    } else {
      // Jika kuantitas 0 atau kurang, hapus item
      await removeFromCart(cartItemId);
    }
  }
}