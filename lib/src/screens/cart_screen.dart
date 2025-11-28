import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/orders_provider.dart';
import '../models/order.dart';
import 'order_detail_screen.dart';
import 'payment_methods_screen.dart';
import '../utils/price_utils.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: cart.items.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: CircleAvatar(
                            child: Text(item.product.title.substring(0, 1))),
                        title: Text(
                          item.product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          formatCOP(item.product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => notifier.changeQty(item.product,
                                  item.qty - 1 > 0 ? item.qty - 1 : 1),
                              icon: const Icon(Icons.remove),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: Text(item.qty.toString()),
                            ),
                            IconButton(
                              onPressed: () => notifier.changeQty(
                                  item.product, item.qty + 1),
                              icon: const Icon(Icons.add),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                            IconButton(
                              onPressed: () => notifier.remove(item.product),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 32, minHeight: 32),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total: ${formatCOP(cart.total)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          final preferred = ref.read(preferredPaymentProvider);
                          if (preferred == null) {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: const Text('Método de pago'),
                                      content: const Text(
                                          'No hay un método de pago preferido. ¿Quieres abrir métodos de pago?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancelar')),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const PaymentMethodsScreen()));
                                            },
                                            child: const Text('Abrir'))
                                      ],
                                    ));
                            return;
                          }

                          final orderItems = cart.items
                              .map((c) =>
                                  OrderItem(product: c.product, qty: c.qty))
                              .toList();
                          final subtotal = cart.total;
                          final shipping = 5.0;
                          final taxes = double.parse(
                              (subtotal * 0.07).toStringAsFixed(2));
                          final id =
                              'ORD${DateTime.now().millisecondsSinceEpoch}';
                          final order = Order(
                              id: id,
                              date: DateTime.now(),
                              status: 'Pending',
                              items: orderItems,
                              subtotal: subtotal,
                              shipping: shipping,
                              taxes: taxes);

                          ref.read(ordersProvider.notifier).addOrder(order);
                          notifier.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Orden creada')));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OrderDetailScreen(order: order)));
                        },
                        child: const Text('Pagar ahora'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
