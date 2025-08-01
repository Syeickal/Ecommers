import 'package:cloud_firestore/cloud_firestore.dart'; // <-- PERBAIKAN DI SINI

class UserAddress {
  final String id;
  final String recipientName;
  final String phoneNumber;
  final String fullAddress;
  final String label; // Contoh: Rumah, Kantor
  final bool isPrimary;

  UserAddress({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.fullAddress,
    required this.label,
    this.isPrimary = false,
  });

  // Konversi dari Firestore doc ke object UserAddress
  factory UserAddress.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserAddress(
      id: doc.id,
      recipientName: data['recipientName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      fullAddress: data['fullAddress'] ?? '',
      label: data['label'] ?? 'Alamat',
      isPrimary: data['isPrimary'] ?? false,
    );
  }

  // Konversi dari object UserAddress ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'fullAddress': fullAddress,
      'label': label,
      'isPrimary': isPrimary,
    };
  }
}