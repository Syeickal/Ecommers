import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/detail_screen.dart';
import 'package:ecommerce_app/services/wishlist_service.dart';
import 'package:ecommerce_app/widgets/product_card.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Keinginan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _wishlistService.getWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Wishlist Anda kosong',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          final wishlistedDocs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: wishlistedDocs.length,
            itemBuilder: (context, index) {
              final doc = wishlistedDocs[index];
              final productData = doc.data() as Map<String, dynamic>;

              final product = Product(
                id: doc.id,
                name: productData['name'] ?? 'No Name',
                price: (productData['price'] ?? 0.0).toDouble(),
                imageUrl: productData['imageUrl'] ?? '',
                description: productData['description'] ?? 'No Description',
                // ================= PERBAIKAN DI SINI =================
                category: productData['category'] ?? 'Lainnya', // Tambahkan argumen category
                // =====================================================
              );

              return ProductCard(
                product: product,
                onAdd: () {
                  // Tambahkan logika add to cart jika diperlukan
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}