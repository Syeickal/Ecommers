import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/screens/success_screen.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:flutter/material.dart';

// Class sederhana untuk merepresentasikan metode pembayaran
class PaymentMethod {
  final String name;
  final String asset;

  PaymentMethod({required this.name, required this.asset});
}

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  const CheckoutScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  // --- PERBAIKAN UTAMA DI SINI ---
  // Gunakan path lengkap dan benar untuk setiap aset
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(name: 'Transfer Bank', asset: 'assets/images/bca.png'),
    PaymentMethod(name: 'GoPay', asset: 'assets/images/gopay.png'),
    PaymentMethod(name: 'OVO', asset: 'assets/images/ovo.png'),
    PaymentMethod(name: 'DANA', asset: 'assets/images/dana.png'),
    PaymentMethod(name: 'Bayar di Tempat (COD)', asset: 'assets/images/cod.png'),
  ];
  PaymentMethod? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    if (_paymentMethods.isNotEmpty) {
      _selectedPaymentMethod = _paymentMethods[0];
    }
  }
  // --- AKHIR PERBAIKAN ---

  void _placeOrder() async {
    if (_formKey.currentState!.validate() && _selectedPaymentMethod != null) {
      setState(() => _isLoading = true);
      try {
        await _orderService.createOrder(
          cartItems: widget.cartItems,
          totalPrice: _calculateTotalPrice(),
          shippingAddress: _addressController.text,
          paymentMethod: _selectedPaymentMethod!.name,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SuccessScreen()),
              (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: ${e.toString()}')),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih metode pembayaran.')),
      );
    }
  }

  double _calculateTotalPrice() {
    return widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ringkasan Pesanan', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _buildOrderSummary(),
              const Divider(height: 32),
              Text('Alamat Pengiriman', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Masukkan alamat lengkap Anda...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Text('Metode Pembayaran', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: RadioListTile<PaymentMethod>(
                      value: method,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (PaymentMethod? value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                      title: Text(method.name),
                      // Panggil aset langsung dari `method.asset`
                      secondary: Image.asset(method.asset, width: 40),
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final item = widget.cartItems[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item.imageUrl),
            ),
            title: Text(item.name),
            subtitle: Text('${item.quantity} x Rp. ${item.price.toStringAsFixed(0)}'),
            trailing: Text('Rp. ${(item.quantity * item.price).toStringAsFixed(0)}'),
          );
        },
      ),
    );
  }

  Widget _buildBottomSheet() {
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
              const Text('Total Bayar:'),
              Text(
                'Rp. ${_calculateTotalPrice().toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _placeOrder,
            icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.lock_outline),
            label: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white,))
                : const Text('Buat Pesanan'),
          ),
        ],
      ),
    );
  }
}