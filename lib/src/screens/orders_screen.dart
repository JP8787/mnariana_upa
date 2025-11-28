import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_provider.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis órdenes')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, i) {
          final o = orders[i];
          return ListTile(
            title: Text(o.id),
            subtitle: Text(
                '${o.status} • ${o.date.toLocal().toString().split(' ').first}'),
            trailing: Text('€${o.total.toStringAsFixed(2)}'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => OrderDetailScreen(order: o))),
          );
        },
      ),
    );
  }
}
