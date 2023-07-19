import 'package:http/http.dart' as http;

import '../utilities/common.dart';
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

  static Future<http.Response> getProducts({String? token}) {
    return http.get(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: baseUrl,
      ),
      headers: generateHeader(token: token),
    );
  }

  static Future<http.Response> searchFor(String query, {String? token}) {
    return http.get(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$baseUrl/search/$query',
      ),
      headers: generateHeader(token: token),
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
}
