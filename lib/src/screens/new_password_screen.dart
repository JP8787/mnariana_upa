import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordState();
}

class _NewPasswordState extends ConsumerState<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String oldPass = '';
  String newPass = '';
  String newPass2 = '';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    if (newPass != newPass2) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña cambiada (simulado)')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Contraseña actual'),
                validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                onSaved: (v) => oldPass = v ?? ''),
            TextFormField(
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Nueva contraseña'),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 chars' : null,
                onSaved: (v) => newPass = v ?? ''),
            TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Repetir nueva contraseña'),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Min 6 chars' : null,
                onSaved: (v) => newPass2 = v ?? ''),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _submit, child: const Text('Guardar'))
          ]),
        ),
      ),
    );
  }
}
