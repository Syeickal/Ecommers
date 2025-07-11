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
        title: Text('Detail Pesanan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Informasi Ringkas Pesanan
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Pesanan: #${order.id}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Tanggal: ${DateFormat('d MMMM yyyy, HH:mm').format(order.timestamp.toDate())}'),
                  SizedBox(height: 8),
                  Text('Status: ${order.status}'),
                  SizedBox(height: 8),
                  Text('Total: Rp. ${order.totalPrice.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // Daftar Item
          Text('Item yang Dipesan', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 10),
          ...order.items.map((item) {
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                title: Text(item.name),
                subtitle: Text('${item.quantity} x Rp. ${item.price.toStringAsFixed(0)}'),
                trailing: Text('Rp. ${(item.quantity * item.price).toStringAsFixed(0)}'),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}