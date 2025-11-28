import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartNotifier = ref.read(cartProvider.notifier);

    final hasSizes = product.sizes.isNotEmpty;
    final hasColors = product.colors.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-image-${product.id}',
              child: Container(
                height: 320,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: product.images.isNotEmpty
                    ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.broken_image,
                              size: 72, color: Colors.grey[600]),
                        ),
                      )
                    : Center(
                        child: Icon(Icons.devices,
                            size: 72, color: Colors.grey[600])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.amber[700]),
                      const SizedBox(width: 6),
                      Text(product.rating.toStringAsFixed(1)),
                      const Spacer(),
                      Text('€${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (hasSizes) ...[
                    Text('Tallas',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.sizes
                          .map((s) => ChoiceChip(
                              label: Text(s),
                              selected: _selectedSize == s,
                              onSelected: (_) =>
                                  setState(() => _selectedSize = s)))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (hasColors) ...[
                    Text('Colores',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.colors
                          .map((c) => ChoiceChip(
                              label: Text(c),
                              selected: _selectedColor == c,
                              onSelected: (_) =>
                                  setState(() => _selectedColor = c)))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text('Descripción',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (hasSizes && _selectedSize == null)
                          ? null
                          : () {
                              cartNotifier.add(product,
                                  selectedSize: _selectedSize,
                                  selectedColor: _selectedColor);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Producto añadido al carrito')));
                            },
                      child: Text(hasSizes && _selectedSize == null
                          ? 'Selecciona una talla'
                          : 'Añadir al carrito'),
                    ),
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
