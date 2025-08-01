import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Informasi Pesanan'),
            _buildInfoCard([
              _buildInfoRow('Order ID', order.orderId),
              _buildInfoRow('Tanggal', DateFormat('d MMMM yyyy, HH:mm').format(order.createdAt.toDate())),
              // --- TAMBAHKAN TAMPILAN METODE PEMBAYARAN ---
              _buildInfoRow('Metode Pembayaran', order.paymentMethod),
              // --- AKHIR PENAMBAHAN ---
              _buildInfoRow('Status', order.status, color: Colors.orange.shade700),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Alamat Pengiriman'),
            _buildInfoCard([
              Text(order.shippingAddress, style: const TextStyle(height: 1.5)),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(context, 'Rincian Produk'),
            _buildProductList(context),
          ],
        ),
      ),
      bottomSheet: _buildTotalSection(context),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.items.length,
        separatorBuilder: (context, index) => Divider(height: 1, indent: 16, endIndent: 16,),
        itemBuilder: (context, index) {
          final item = order.items[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item['imageUrl'] ?? ''),
            ),
            title: Text(item['name'] ?? 'Nama Produk Tidak Tersedia'),
            subtitle: Text(
                '${item['quantity']} x Rp. ${NumberFormat('#,##0').format(item['price'])}'),
            trailing: Text(
              'Rp. ${NumberFormat('#,##0').format(item['quantity'] * item['price'])}',
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Pesanan', style: Theme.of(context).textTheme.titleMedium),
          Text(
            'Rp. ${NumberFormat('#,##0').format(order.totalPrice)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}