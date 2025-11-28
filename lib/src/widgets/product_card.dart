import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../utils/price_utils.dart';
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
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ));
        },
        child: Column(
          children: [
            // Imagen con overlay y título encima
            Stack(
              children: [
                Hero(
                  tag: 'product-image-${product.id}',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: product.images.isNotEmpty
                          ? Image.network(
                              product.images.first,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
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
                ),
                // degradado inferior para legibilidad del texto
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.35)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                // título sobre la imagen (inferior izquierda)
                Positioned(
                  left: 12,
                  bottom: 8,
                  right: 56,
                  child: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 2)
                        ]),
                  ),
                ),
                // favorito pequeño (esquina superior derecha)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? primary : Colors.black54,
                        size: 18,
                      ),
                      onPressed: () {
                        final list =
                            List<String>.from(ref.read(favoritesProvider));
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
              ],
            ),

            // cuerpo con rating, specs breves y precio
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // rating y mini-spec (si aplica)
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber[700]),
                      const SizedBox(width: 6),
                      Text(product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 8),
                      // mostrar primera spec cuando exista (ej: RAM/CPU)
                      if (product.specs.isNotEmpty)
                        Flexible(
                          child: Text(
                            '• ${product.specs.entries.first.value}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // precio y botón añadir (alineados)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatCOP(product.price),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                      // botón discreto añadir al carrito (menos intrusivo)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            if (product.sizes.isNotEmpty) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      ProductDetailScreen(product: product)));
                              return;
                            }
                            try {
                              cartNotifier.add(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${product.title} añadido'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Error al añadir al carrito. Intenta de nuevo.')),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: surface.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 6)
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add_shopping_cart,
                                    size: 16, color: primary),
                                const SizedBox(width: 6),
                                const Text('Añadir',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
