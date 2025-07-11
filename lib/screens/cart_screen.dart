import 'package:ecommerce_app/screens/checkout_screen.dart'; // <-- IMPORT HALAMAN BARU
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  // HAPUS LOGIKA _placeOrder DAN _isPlacingOrder DARI SINI

  Widget _buildBottomSheet(List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      return const SizedBox.shrink();
    }

    double totalPrice = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, -3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Harga:', style: Theme.of(context).textTheme.bodyMedium),
              Text('Rp. ${totalPrice.toStringAsFixed(0)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).primaryColor)),
            ],
          ),
          // UBAH FUNGSI TOMBOL INI
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(cartItems: cartItems),
                ),
              );
            },
            icon: const Icon(Icons.payment),
            label: const Text('Checkout'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
          ),
        ],
      ),
    );
  }

  // Sisa kode (build, _buildCartList) tetap sama...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Saya'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cartService.getCartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildCartList([]);
          }

          final cartItems = snapshot.data!.docs.map((doc) => CartItem.fromFirestore(doc)).toList();

          return _buildCartList(cartItems);
        },
      ),
      bottomSheet: StreamBuilder<QuerySnapshot>(
        stream: _cartService.getCartStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          final cartItems = snapshot.data!.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
          return _buildBottomSheet(cartItems);
        },
      ),
    );
  }

  Widget _buildCartList(List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart_outlined, size: 100, color: Colors.grey.shade400),
            SizedBox(height: 20),
            Text('Keranjang Anda Kosong', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600)),
            SizedBox(height: 8),
            Text('Ayo tambahkan beberapa produk!', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(item.imageUrl)),
            title: Text(item.name),
            subtitle: Text('Rp. ${item.price.toStringAsFixed(0)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
                  onPressed: () => _cartService.updateQuantity(item.id, item.quantity - 1),
                ),
                Text(item.quantity.toString(), style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                  onPressed: () => _cartService.updateQuantity(item.id, item.quantity + 1),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _cartService.removeFromCart(item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}