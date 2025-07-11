import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan UID pengguna yang sedang login
  String? get _uid => _auth.currentUser?.uid;

  // Mendapatkan referensi dokumen wishlist untuk produk tertentu
  DocumentReference _getWishlistDocRef(String productId) {
    if (_uid == null) {
      throw Exception("Pengguna belum login");
    }
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('wishlist')
        .doc(productId);
  }

  // Menambah/menghapus produk dari wishlist
  Future<void> toggleWishlist(String productId, Map<String, dynamic> productData) async {
    final docRef = _getWishlistDocRef(productId);
    final doc = await docRef.get();

    if (doc.exists) {
      // Jika sudah ada, hapus dari wishlist
      await docRef.delete();
    } else {
      // Jika belum ada, tambahkan ke wishlist beserta data produk
      await docRef.set(productData);
    }
  }

  // Memeriksa apakah produk ada di wishlist (untuk update UI real-time)
  Stream<bool> isWishlisted(String productId) {
    if (_uid == null) return Stream.value(false);
    return _getWishlistDocRef(productId).snapshots().map((snapshot) {
      return snapshot.exists;
    });
  }

  // Mendapatkan semua item di wishlist
  Stream<QuerySnapshot> getWishlistStream() {
    if (_uid == null) return Stream.empty();
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('wishlist')
        .snapshots();
  }
}