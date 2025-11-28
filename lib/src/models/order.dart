import 'product.dart';

class OrderItem {
  final Product product;
  final int qty;
  OrderItem({required this.product, required this.qty});

  Map<String, dynamic> toJson() => {'product': product.toJson(), 'qty': qty};
}

class Order {
  final String id;
  final DateTime date;
  final String status;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double taxes;

  Order(
      {required this.id,
      required this.date,
      required this.status,
      required this.items,
      required this.subtotal,
      required this.shipping,
      required this.taxes});

  double get total => subtotal + shipping + taxes;

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'].toString(),
        date: DateTime.tryParse(j['date']) ?? DateTime.now(),
        status: j['status'] ?? 'pending',
        items: (j['items'] as List? ?? [])
            .map((e) => OrderItem(
                product: Product.fromJson(e['product']), qty: e['qty']))
            .toList(),
        subtotal: (j['subtotal'] ?? 0).toDouble(),
        shipping: (j['shipping'] ?? 0).toDouble(),
        taxes: (j['taxes'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'status': status,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'shipping': shipping,
        'taxes': taxes,
      };
}
