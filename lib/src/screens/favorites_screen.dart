import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final products = ref.watch(productsProvider);
    final favProducts = products.where((p) => favIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Product')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: favProducts.isEmpty
            ? const Center(child: Text('No favorites yet'))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12),
                itemCount: favProducts.length,
                itemBuilder: (context, i) => Column(children: [
                  Expanded(child: ProductCard(product: favProducts[i])),
                ]),
              ),
      ),
    );
  }
}
