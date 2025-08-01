import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan stream wishlist untuk user yang sedang login
  Stream<List<String>> getWishlistProductIds() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Mendapatkan data produk dari wishlist
  Stream<List<Product>> getWishlistProducts() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .snapshots()
        .asyncMap((wishlistSnapshot) async {
      List<Product> wishlistProducts = [];
      for (var doc in wishlistSnapshot.docs) {
        final productDoc = await _firestore.collection('products').doc(doc.id).get();
        if (productDoc.exists) {
          wishlistProducts.add(Product.fromFirestore(productDoc.data()!, productDoc.id));
        }
      }
      return wishlistProducts;
    });
  }


  // Menambah atau menghapus produk dari wishlist
  Future<void> toggleWishlist(String productId, Map<String, dynamic> productData) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Anda harus login untuk menggunakan wishlist.");
    }
    final wishlistRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wishlist')
        .doc(productId);

    final doc = await wishlistRef.get();
    if (doc.exists) {
      // Jika sudah ada, hapus dari wishlist
      await wishlistRef.delete();
    } else {
      // Jika belum ada, tambahkan ke wishlist
      await wishlistRef.set(productData);
    }
  }
}