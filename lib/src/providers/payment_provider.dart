import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_method.dart';

final paymentMethodsProvider = StateProvider<List<PaymentMethod>>((ref) => [
      PaymentMethod(
          id: 'pm1',
          type: 'credit_card',
          label: 'Visa ****1111',
          details: {'last4': '1111'}),
      PaymentMethod(
          id: 'pm2',
          type: 'paypal',
          label: 'paypal@example.com',
          details: null),
    ]);

final preferredPaymentProvider = StateProvider<PaymentMethod?>((ref) => null);

class PaymentService {
  final Ref ref;
  PaymentService(this.ref);

  void setPreferred(PaymentMethod pm) {
    ref.read(preferredPaymentProvider.notifier).state = pm;
  }

  void addPaymentMethod(PaymentMethod pm) {
    final list = [...ref.read(paymentMethodsProvider)];
    list.add(pm);
    ref.read(paymentMethodsProvider.notifier).state = list;
  }
}

final paymentServiceProvider = Provider((ref) => PaymentService(ref));
