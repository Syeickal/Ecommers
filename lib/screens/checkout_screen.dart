import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedPaymentMethod;
  bool _isLoading = false;

  final OrderService _orderService = OrderService();
  final CartService _cartService = CartService();

  final List<String> _paymentMethods = [
    'Transfer Bank',
    'E-Wallet (OVO, GoPay, Dana)',
    'COD (Bayar di Tempat)',
    'Kartu Kredit/Debit'
  ];

  double get _totalPrice {
    return widget.cartItems
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> _placeOrder() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _orderService.createOrder(widget.cartItems, _selectedPaymentMethod!);
      await _cartService.clearCart();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset('assets/succes.json', width: 150, height: 150, repeat: false),
                  const SizedBox(height: 20),
                  Text("Pesanan Berhasil!", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text("Terima kasih telah berbelanja.", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    child: const Text("OK", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      // Kembali ke halaman utama (root)
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pesanan: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Ringkasan Pesanan', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...widget.cartItems.map((item) {
            return ListTile(
              title: Text('${item.name} (x${item.quantity})'),
              trailing: Text('Rp. ${(item.price * item.quantity).toStringAsFixed(0)}'),
            );
          }),
          const Divider(),
          ListTile(
            title: Text('Total Harga', style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text('Rp. ${_totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Text('Pilih Metode Pembayaran', style: Theme.of(context).textTheme.titleLarge),
          ..._paymentMethods.map((method) {
            return RadioListTile<String>(
              title: Text(method),
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            );
          }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
          onPressed: _placeOrder,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Buat Pesanan'),
        ),
      ),
    );
  }
}