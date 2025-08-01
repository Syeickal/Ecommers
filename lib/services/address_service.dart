import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_address.dart';

class AddressService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan collection alamat untuk user yang sedang login
  CollectionReference<Map<String, dynamic>> _getAddressCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User tidak login.");
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses');
  }

  // Mendapatkan stream daftar alamat
  Stream<List<UserAddress>> getAddresses() {
    return _getAddressCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserAddress.fromFirestore(doc)).toList();
    });
  }

  // Menambah alamat baru
  Future<void> addAddress(UserAddress address) async {
    await _getAddressCollection().add(address.toMap());
  }

  // Memperbarui alamat yang sudah ada
  Future<void> updateAddress(UserAddress address) async {
    await _getAddressCollection().doc(address.id).update(address.toMap());
  }

  // Menghapus alamat
  Future<void> deleteAddress(String addressId) async {
    await _getAddressCollection().doc(addressId).delete();
  }
}