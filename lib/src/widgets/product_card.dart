import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);
    final isFav = favs.contains(product.id);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'product-image-${product.id}',
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: product.images.isNotEmpty
                        ? Image.network(
                            product.images.first,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ));
                            },
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(Icons.broken_image, size: 40, color: Colors.grey[600]),
                            ),
                          )
                        : Center(
                            child: Icon(Icons.devices, size: 48, color: Colors.grey[600]),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('€${product.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white70,
              child: IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black87, size: 18),
                onPressed: () {
                  final list = List<String>.from(ref.read(favoritesProvider));
                  if (isFav) {
                    list.remove(product.id);
                  } else {
                    list.add(product.id);
                  }
                  ref.read(favoritesProvider.notifier).state = list;
                },
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton(
              mini: true,
              onPressed: () {
                // If product requires size selection, open detail
                if (product.sizes.isNotEmpty) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                  return;
                }
                cartNotifier.add(product);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito')));
              },
              child: const Icon(Icons.add_shopping_cart, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-image-${product.id}',
              child: Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: product.images.isNotEmpty
                    ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)));
                        },
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey[600]),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.devices,
                            size: 48, color: Colors.grey[600]),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(product.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        import 'package:flutter/material.dart';
                        import 'package:flutter_riverpod/flutter_riverpod.dart';
                        import '../models/product.dart';
                        import '../screens/product_detail_screen.dart';
                        import '../providers/favorites_provider.dart';
                        import '../providers/cart_provider.dart';

                        class ProductCard extends ConsumerWidget {
                          final Product product;
                          const ProductCard({super.key, required this.product});

                          @override
                          Widget build(BuildContext context, WidgetRef ref) {
                            final favs = ref.watch(favoritesProvider);
                            final isFav = favs.contains(product.id);
                            final cartNotifier = ref.read(cartProvider.notifier);

                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(product: product),
                                    ));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: 'product-image-${product.id}',
                                        child: Container(
                                          height: 140,
                                          width: double.infinity,
                                          color: Colors.grey.shade200,
                                          child: product.images.isNotEmpty
                                              ? Image.network(
                                                  product.images.first,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)));
                                                  },
                                                  errorBuilder: (context, error, stackTrace) => Center(
                                                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey[600]),
                                                  ),
                                                )
                                              : Center(
                                                  child: Icon(Icons.devices, size: 48, color: Colors.grey[600]),
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(product.title,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.bodyLarge),
                                            const SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                                                    const SizedBox(width: 4),
                                                    Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)),
                                                  ],
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text('€${product.price.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 8,
                                    right: 8,
                                    child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.white70,
                                        child: IconButton(
                                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.black87, size: 18),
                                            onPressed: () {
                                              final list = List<String>.from(ref.read(favoritesProvider));
                                              if (isFav) {
                                                list.remove(product.id);
                                              } else {
                                                list.add(product.id);
                                              }
                                              ref.read(favoritesProvider.notifier).state = list;
                                            }))),
                                Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: FloatingActionButton(
                                      mini: true,
                                      onPressed: () {
                                        // If product requires size selection, open detail
                                        if (product.sizes.isNotEmpty) {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                                          return;
                                        }
                                        cartNotifier.add(product);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito')));
                                      },
                                      child: const Icon(Icons.add_shopping_cart, size: 18),
                                    ))
                              ]),
                            );
                          }
                        }
