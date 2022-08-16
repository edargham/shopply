import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

import './common.dart';

class ProductService {
  static const String _productsUrl = '/products.json';

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
}
