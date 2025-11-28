import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import 'gender_screen.dart';
import 'login_screen.dart';
import 'new_password_screen.dart';
import 'change_email_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editProfileDialog(BuildContext context, WidgetRef ref) async {
    final u = ref.read(userProvider);
    if (u == null) return;
    final nameCtrl = TextEditingController(text: u.name);
    final avatarCtrl = TextEditingController(text: u.avatarUrl ?? '');

    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Editar perfil'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(
                  controller: avatarCtrl,
                  decoration: const InputDecoration(labelText: 'Avatar URL')),
            ]),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar')),
              ElevatedButton(
                  onPressed: () {
                    final updated = u
                      ..name = nameCtrl.text.trim()
                      ..avatarUrl = avatarCtrl.text.trim().isEmpty
                          ? null
                          : avatarCtrl.text.trim();
                    ref.read(userUpdaterProvider).updateProfile(updated);
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authProvider);

    if (auth.user == null && user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: const Text('Iniciar sesión')),
        ),
      );
    }

    final u = user ?? auth.user!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Stack(children: [
              CircleAvatar(
                  radius: 44,
                  backgroundImage:
                      u.avatarUrl != null ? NetworkImage(u.avatarUrl!) : null,
                  child: u.avatarUrl == null
                      ? Text(u.name.substring(0, 1).toUpperCase())
                      : null),
              Positioned(
                  right: -6,
                  bottom: -6,
                  child: IconButton(
                      onPressed: () => _editProfileDialog(context, ref),
                      icon: const Icon(Icons.edit, size: 18)))
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Expanded(
                          child: Text(u.email,
                              style: const TextStyle(color: Colors.grey))),
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Verificación enviada (simulado)')));
                          },
                          child: const Text('Verificar'))
                    ])
                  ]),
            )
          ]),
          const SizedBox(height: 20),
          Card(
            child: Column(children: [
              ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Gender'),
                  subtitle: Text(u.gender ?? 'Not set'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GenderScreen()))),
              const Divider(height: 1),
              ListTile(
                  leading: const Icon(Icons.cake_outlined),
                  title: const Text('Birthday'),
                  subtitle: Text(u.birthday != null
                      ? u.birthday!.toLocal().toString().split(' ').first
                      : 'Not set'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {}),
              const Divider(height: 1),
              ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(u.email),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ChangeEmailScreen()))),
              const Divider(height: 1),
              ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: const Text('Phone Number'),
                  subtitle: Text(u.phone ?? 'Not set'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {}),
              const Divider(height: 1),
              ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NewPasswordScreen()))),
            ]),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar sesión'))
        ],
      ),
    );
  }
}
