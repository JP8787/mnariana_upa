import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});
  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final u = ref.read(userProvider);
    if (u != null) {
      u.email = email;
      ref.read(userUpdaterProvider).updateProfile(u);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Verification email sent')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final u = ref.read(userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Change Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
                initialValue: u?.email ?? '',
                decoration: const InputDecoration(labelText: 'New Email'),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Invalid' : null,
                onSaved: (v) => email = v ?? ''),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _submit, child: const Text('Change Email'))
          ]),
        ),
      ),
    );
  }
}
