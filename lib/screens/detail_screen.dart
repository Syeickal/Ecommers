import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:ecommerce_app/services/wishlist_service.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final WishlistService _wishlistService = WishlistService();
  final CartService _cartService = CartService();

  // Untuk galeri gambar, kita akan duplikat gambar utama untuk demo
  late final List<String> galleryImages;

  @override
  void initState() {
    super.initState();
    galleryImages = [
      widget.product.imageUrl,
      // Tambahkan gambar lain jika ada, atau duplikat untuk efek galeri
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
      'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500',
    ];
  }

  void addToCart() {
    _cartService.addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product.name} ditambahkan ke keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar dengan gambar produk
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    galleryImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                  );
                },
              ),
            ),
          ),
          // Konten detail produk
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Text(
                    'Rp. ${widget.product.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Deskripsi
                  Text(
                    "Deskripsi",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      // Bottom Navigation Bar untuk tombol aksi
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ],
        ),
        child: Row(
          children: [
            // Tombol Wishlist
            StreamBuilder<bool>(
              stream: _wishlistService.isWishlisted(widget.product.id),
              builder: (context, snapshot) {
                final isWishlisted = snapshot.data ?? false;
                return IconButton.outlined(
                  onPressed: () {
                    _wishlistService.toggleWishlist(widget.product.id, widget.product.toJson());
                  },
                  icon: Icon(
                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWishlisted ? Colors.red : Colors.grey,
                  ),
                  style: IconButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      minimumSize: Size(50, 50)
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            // Tombol Tambah ke Keranjang
            Expanded(
              child: ElevatedButton.icon(
                onPressed: addToCart,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Tambah ke Keranjang"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}