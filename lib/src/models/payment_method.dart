class PaymentMethod {
  final String id;
  final String type; // e.g. credit_card, paypal
  final String label;
  final Map<String, dynamic>? details;

  PaymentMethod(
      {required this.id,
      required this.type,
      required this.label,
      this.details});

  factory PaymentMethod.fromJson(Map<String, dynamic> j) => PaymentMethod(
        id: j['id'].toString(),
        type: j['type'] ?? '',
        label: j['label'] ?? '',
        details: j['details'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'type': type, 'label': label, 'details': details};
}
