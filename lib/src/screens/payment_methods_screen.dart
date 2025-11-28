import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payment_provider.dart';
import '../models/payment_method.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentMethodsProvider);
    final preferred = ref.watch(preferredPaymentProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Medios de pago')),
      body: ListView.builder(
        itemCount: methods.length,
        itemBuilder: (context, i) {
          final m = methods[i];
          final isPref = preferred?.id == m.id;
          return ListTile(
            title: Text(m.label),
            subtitle: Text(m.type),
            trailing: isPref
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            onTap: () {
              ref.read(paymentServiceProvider).setPreferred(m);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Método preferido seleccionado')));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await showDialog<Map<String, String>>(
              context: context,
              builder: (_) {
                final typeCtrl = TextEditingController();
                final labelCtrl = TextEditingController();
                return AlertDialog(
                  title: const Text('Agregar método'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(
                        controller: labelCtrl,
                        decoration: const InputDecoration(labelText: 'Label')),
                    TextField(
                        controller: typeCtrl,
                        decoration: const InputDecoration(labelText: 'Type')),
                  ]),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context,
                            {'label': labelCtrl.text, 'type': typeCtrl.text}),
                        child: const Text('Agregar')),
                  ],
                );
              });
          if (res != null) {
            final pm = PaymentMethod(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                type: res['type'] ?? 'card',
                label: res['label'] ?? 'Nuevo',
                details: null);
            ref.read(paymentServiceProvider).addPaymentMethod(pm);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
