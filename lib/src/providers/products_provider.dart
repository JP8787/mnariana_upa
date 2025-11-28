import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final searchProvider = StateProvider<String>((ref) => '');
final categoryProvider = StateProvider<String>((ref) => 'All');

final productsProvider = Provider<List<Product>>((ref) {
  // Mock data — en producción cargar desde ApiService
  final raw = [
    {
      'id': 'p1',
      'title': 'Auriculares inalámbricos X200',
      'description':
          'Auriculares con cancelación de ruido y batería de larga duración',
      'price': 79.99,
      'images': [
        'https://images.unsplash.com/photo-1518444027927-3f6aa0f7c0f0?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black', 'White'],
      'category': 'Audio',
      'stock': 12,
      'rating': 4.4
    },
    {
      'id': 'p2',
      'title': 'Teclado Mecánico Pro',
      'description': 'Teclado con switches táctiles y retroiluminación RGB',
      'price': 99.99,
      'images': [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black'],
      'category': 'Peripherals',
      'stock': 8,
      'rating': 4.6
    },
    {
      'id': 'p3',
      'title': 'Monitor UltraSharp 27"',
      'description': 'Monitor 4K con colores precisos y panel IPS',
      'price': 299.99,
      'images': [
        'https://images.unsplash.com/photo-1517336716367-5b8f2a0f3c7a?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': [],
      'category': 'Monitors',
      'stock': 5,
      'rating': 4.7
    },
    {
      'id': 'p4',
      'title': 'Mouse Gamer Viper',
      'description': 'Sensor de alta precisión y diseño ergonómico',
      'price': 49.99,
      'images': [
        'https://images.unsplash.com/photo-1585386959984-a4155223f5c6?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black', 'Green'],
      'category': 'Peripherals',
      'stock': 20,
      'rating': 4.2
    },
    {
      'id': 'p5',
      'title': 'Soporte para Laptop',
      'description': 'Soporte ajustable para laptop con refrigeración',
      'price': 29.99,
      'images': [
        'https://images.unsplash.com/photo-1555617117-08fda1f3b6b8?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Silver'],
      'category': 'Accessories',
      'stock': 15,
      'rating': 4.0
    },
    {
      'id': 'p6',
      'title': 'Auriculares Deportivos',
      'description': 'Resistentes al sudor con ajuste seguro para deporte',
      'price': 59.99,
      'images': [
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black', 'Blue'],
      'category': 'Audio',
      'stock': 10,
      'rating': 4.1
    },
    // Hardware example: procesador
    {
      'id': 'p12',
      'title': 'Procesador Ryzen 5 5600X',
      'description':
          'Procesador AMD de alto rendimiento para gaming y productividad',
      'price': 199.0,
      'images': [
        'https://images.unsplash.com/photo-1588615402798-6b5b8a0f3c6a?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': [],
      'category': 'Components',
      'stock': 6,
      'rating': 4.8,
      'specs': {
        'Cores': '6',
        'Threads': '12',
        'Base': '3.7 GHz',
        'Boost': '4.6 GHz',
        'Socket': 'AM4',
        'TDP': '65W'
      }
    },
    {
      'id': 'p13',
      'title': 'Kit RAM 16GB (2x8) DDR4 3200MHz',
      'description':
          'Memoria RAM rápida para mejorar el rendimiento del sistema',
      'price': 79.0,
      'images': [
        'https://images.unsplash.com/photo-1587814557552-1f62e5d8b7bb?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': [],
      'category': 'Components',
      'stock': 14,
      'rating': 4.5,
      'specs': {
        'Capacity': '16GB',
        'Config': '2x8GB',
        'Speed': '3200MHz',
        'Type': 'DDR4'
      }
    },
    {
      'id': 'p7',
      'title': 'Cámara Web HD',
      'description':
          'Cámara para streaming y videollamadas con micrófono integrado',
      'price': 39.99,
      'images': [
        'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': [],
      'category': 'Peripherals',
      'stock': 18,
      'rating': 4.3
    },
    {
      'id': 'p8',
      'title': 'Altavoz Bluetooth Compacto',
      'description': 'Sonido potente en formato portátil',
      'price': 69.99,
      'images': [
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Red', 'Black'],
      'category': 'Audio',
      'stock': 7,
      'rating': 4.0
    },
    {
      'id': 'p9',
      'title': 'Base de Carga USB-C',
      'description': 'Base con múltiples puertos para carga rápida',
      'price': 24.99,
      'images': [
        'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black'],
      'category': 'Accessories',
      'stock': 25,
      'rating': 3.9
    },
    {
      'id': 'p10',
      'title': 'Soporte de Micrófono',
      'description': 'Brazo articulado para micrófono de estudio',
      'price': 34.99,
      'images': [
        'https://images.unsplash.com/photo-1517167685289-5d8c7d6a6b3b?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black'],
      'category': 'Accessories',
      'stock': 9,
      'rating': 4.1
    },
    {
      'id': 'p11',
      'title': 'Alfombrilla RGB',
      'description': 'Alfombrilla para teclado con iluminación RGB',
      'price': 19.99,
      'images': [
        'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=800&q=80'
      ],
      'sizes': [],
      'colors': ['Black'],
      'category': 'Accessories',
      'stock': 30,
      'rating': 4.0
    }
  ];

  return raw.map((e) {
    final j = Map<String, dynamic>.from(e);
    return Product(
      id: j['id'] as String,
      title: j['title'] as String,
      description: j['description'] as String,
      price: (j['price'] as num).toDouble(),
      images: List<String>.from(j['images'] as List<dynamic>),
      sizes: List<String>.from(j['sizes'] as List<dynamic>),
      colors: List<String>.from(j['colors'] as List<dynamic>),
      category: j['category'] as String,
      stock: (j['stock'] as num).toInt(),
      rating: (j['rating'] as num).toDouble(),
    );
  }).toList();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final all = ref.watch(productsProvider);
  final search = ref.watch(searchProvider).toLowerCase();
  final cat = ref.watch(categoryProvider);

  var list = all.where((p) => cat == 'All' || p.category == cat).toList();
  if (search.isNotEmpty) {
    list = list
        .where((p) =>
            p.title.toLowerCase().contains(search) ||
            p.description.toLowerCase().contains(search))
        .toList();
  }
  return list;
});
