import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

import './common.dart';

class ProductService {
  static const String _productsUrl = '/products.json';
  static const String _productsRoute = '/products';

  static Future<http.Response> addProduct(Product item) {
    return http.post(
      Uri.https(baseUrl, _productsUrl),
      body: json.encode({
        'title': item.title,
        'price': item.price,
        'description': item.description,
        'itemUrl': item.imageUrl,
        'isFavorite': item.isFavorite,
      }),
    );
  }

  static Future<http.Response> getProducts() {
    return http.get(Uri.https(baseUrl, _productsUrl));
  }

  static Future<http.Response> updateProduct(Product item) {
    return http.patch(
      Uri.https(baseUrl, '$_productsRoute/${item.id}.json'),
      body: json.encode({
        'title': item.title,
        'price': item.price,
        'description': item.description,
        'itemUrl': item.imageUrl,
      }),
    );
  }

  static Future<http.Response> deleteProduct(Product item) {
    return http.delete(
      Uri.https(baseUrl, '$_productsRoute/${item.id}.json'),
    );
  }
}
