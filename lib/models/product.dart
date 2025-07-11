class Product {
  String id; // Ubah dari final agar bisa di-set di wishlist_screen
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category; // <-- TAMBAHKAN BARIS INI

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category, // <-- TAMBAHKAN BARIS INI
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? 'No Description',
      category: json['category'] ?? 'Lainnya', // <-- TAMBAHKAN BARIS INI
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'category': category, // <-- TAMBAHKAN BARIS INI
    };
  }

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? 'No Name',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? 'No Description',
      category: data['category'] ?? 'Lainnya', // <-- TAMBAHKAN BARIS INI
    );
  }
}