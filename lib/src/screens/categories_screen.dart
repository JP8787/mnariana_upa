import 'package:flutter/material.dart';
import '../screens/product_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _sections = {
    'Man Fashion': [
      'Man Shirt',
      'Man Work equipment',
      'Man T-Shirt',
      'Man Shoes',
      'Man Pants',
      'Man Underwear'
    ],
    'Woman Fashion': [
      'Dress',
      'Woman T-Shirt',
      'Woman Pants',
      'Woman Bag',
      'High Heels'
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _sections.entries
            .map((e) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.key,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: e.value
                          .map((label) => _CategoryIcon(
                              label: label,
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ProductListScreen()))))
                          .toList()),
                  const SizedBox(height: 18)
                ]))
            .toList(),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CategoryIcon({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: Colors.blue.shade50, shape: BoxShape.circle),
            child: Center(child: Icon(Icons.category, color: Colors.blue))),
        const SizedBox(height: 6),
        SizedBox(
            width: 80,
            child: Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)))
      ]),
    );
  }
}
