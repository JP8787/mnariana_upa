import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orden ${order.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Estado: ${order.status}',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Fecha: ${order.date.toLocal()}'),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: order.items.length,
              itemBuilder: (context, i) {
                final it = order.items[i];
                return ListTile(
                  leading: it.product.images.isNotEmpty
                      ? Image.network(it.product.images.first,
                          width: 56, height: 56, fit: BoxFit.cover)
                      : null,
                  title: Text(it.product.title),
                  subtitle: Text('Qty: ${it.qty}'),
                  trailing: Text(
                      '€${(it.product.price * it.qty).toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Subtotal'),
            Text('€${order.subtotal.toStringAsFixed(2)}')
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Shipping'),
            Text('€${order.shipping.toStringAsFixed(2)}')
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Taxes'),
            Text('€${order.taxes.toStringAsFixed(2)}')
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('€${order.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ]),
        ]),
      ),
    );
  }
}
