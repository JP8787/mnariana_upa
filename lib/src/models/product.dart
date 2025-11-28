/// Modelo simple (sin freezed por simplicidad)
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final String category;
  final int stock;
  final double rating;
  final Map<String, String> specs;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    this.sizes = const [],
    this.colors = const [],
    required this.category,
    required this.stock,
    required this.rating,
    this.specs = const {},
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'].toString(),
        title: j['title'] ?? '',
        description: j['description'] ?? '',
        price: (j['price'] ?? 0).toDouble(),
        images: List<String>.from(j['images'] ?? []),
        sizes: List<String>.from(j['sizes'] ?? []),
        colors: List<String>.from(j['colors'] ?? []),
        specs: Map<String, String>.from(j['specs'] ?? {}),
        category: j['category'] ?? '',
        stock: j['stock'] ?? 0,
        rating: (j['rating'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'images': images,
        'sizes': sizes,
        'colors': colors,
        'specs': specs,
        'category': category,
        'stock': stock,
        'rating': rating,
      };
}
