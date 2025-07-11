import 'package:ecommerce_app/services/wishlist_service.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback? onTap; // onTap sudah ada, kita akan gunakan

  ProductCard({
    Key? key,
    required this.product,
    required this.onAdd,
    this.onTap, // Pastikan ini diterima
  }) : super(key: key);

  final WishlistService _wishlistService = WishlistService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // PASTIKAN CARD DIBUNGKUS DENGAN GESTUREDETECTOR DAN MEMILIKI ONTAP
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.broken_image, color: Colors.grey[400], size: 60),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp. ${product.price.toStringAsFixed(0)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onAdd,
                          child: const Text('Tambah'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: StreamBuilder<bool>(
                stream: _wishlistService.isWishlisted(product.id),
                builder: (context, snapshot) {
                  final isWishlisted = snapshot.data ?? false;
                  return InkWell(
                    onTap: () {
                      _wishlistService.toggleWishlist(product.id, product.toJson());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}