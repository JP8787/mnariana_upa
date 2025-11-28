import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/cart_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final count = cart.items.fold<int>(0, (s, i) => s + i.qty);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CartScreen())),
          icon: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.shopping_cart),
              if (count > 0)
                Positioned(
                  right: 0,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8)),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(count.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center),
                  ),
                ),
            ],
          ),
        ),
        Consumer(builder: (context, ref, _) {
          final auth = ref.watch(authProvider);
          final logged = auth.user != null;
          return IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    logged ? const ProfileScreen() : const LoginScreen())),
            icon: Icon(logged ? Icons.person : Icons.login),
          );
        })
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
