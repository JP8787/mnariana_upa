import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

export 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializaciones (Hive, Stripe, etc) aquí si necesitas
  runApp(ProviderScope(child: MyApp()));
}
