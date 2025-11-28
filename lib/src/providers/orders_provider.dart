import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>(
    (ref) => OrdersNotifier());

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    // mock seed
    _seed();
  }

  void _seed() {
    final now = DateTime.now();
    state = List.generate(
        3,
        (i) => Order(
              id: 'ORD${1000 + i}',
              date: now.subtract(Duration(days: i * 3)),
              status: i == 0
                  ? 'Delivered'
                  : i == 1
                      ? 'Shipping'
                      : 'Packing',
              items: [],
              subtotal: 59.99 + i * 10,
              shipping: 5.0,
              taxes: 3.5,
            ));
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void addOrder(Order o) {
    state = [o, ...state];
  }
}
