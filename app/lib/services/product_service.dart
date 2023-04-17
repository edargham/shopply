import 'package:http/http.dart' as http;

// import '../models/view_models/product.dart';

class ProductService {
  static const String baseUrl = '/api/products/';

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

  static Future<http.Response> getProducts() {
    return http.get(
      Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 3000,
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
