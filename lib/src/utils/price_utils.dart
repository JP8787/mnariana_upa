import 'package:intl/intl.dart';

String formatCOP(double value,
    {double conversionRate = 4600, int decimalDigits = 0}) {
  final copValue = value * conversionRate;
  final formatter = NumberFormat.currency(
      locale: 'es_CO', symbol: 'COP \$', decimalDigits: decimalDigits);
  return formatter.format(copValue);
}
