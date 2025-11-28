import 'package:dio/dio.dart';
import 'package:tienda_tech/src/models/product.dart';

class ApiService {
  final Dio _dio;
  ApiService(String baseUrl) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<Product>> fetchProducts({String? category, int page = 1}) async {
    final res = await _dio.get('/products',
        queryParameters: {'category': category, 'page': page});
    final data = res.data as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> fetchProduct(String id) async {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(res.data);
  }

  // Auth, cart, orders endpoints similares...
}
