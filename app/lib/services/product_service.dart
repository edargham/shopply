import 'dart:convert';

import 'package:http/http.dart' as http;

import './utils/common.dart';
// import '../models/view_models/product.dart';

class ProductService {
  static const String baseUrl = '/api/products/';
  static const String likeUrl = '/api/like/';
  // static Future<http.Response> addProduct(Product item) {
  //   return http.post(
  //     Uri.https(baseUrl, _productsUrl),
  //     body: json.encode({
  //       'title': item.title,
  //       'price': item.price,
  //       'description': item.description,
  //       'itemUrl': item.imageUrl,
  //       'isFavorite': item.isFavorite,
  //     }),
  //   );
  // }

  static Future<http.Response> postLike(String token, String productId) {
    return http.post(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: likeUrl,
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'productId': productId,
      }),
    );
  }

  static Future<http.Response> deleteLike(String token, String productId) {
    return http.delete(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: likeUrl,
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'productId': productId,
      }),
    );
  }

  static Future<http.Response> getProducts() {
    return http.get(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: baseUrl,
      ),
    );
  }

  // static Future<http.Response> updateProduct(Product item) {
  //   return http.patch(
  //     Uri.https(baseUrl, '$_productsRoute/${item.id}.json'),
  //     body: json.encode({
  //       'title': item.title,
  //       'price': item.price,
  //       'description': item.description,
  //       'itemUrl': item.imageUrl,
  //     }),
  //   );
  // }

  // static Future<http.Response> deleteProduct(Product item) {
  //   return http.delete(
  //     Uri.https(baseUrl, '$_productsRoute/${item.id}.json'),
  //   );
  // }

  // static Future<http.Response> setFavorite(String id, bool isFavorite) {
  //   return http.patch(
  //     Uri.https(baseUrl, '$_productsRoute/$id.json'),
  //     body: json.encode({
  //       'isFavorite': isFavorite,
  //     }),
  //   );
  // }
}
