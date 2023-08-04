import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/view_models/product.dart';
import '../utilities/common.dart';
// import '../models/view_models/product.dart';

class ProductService {
  static const String baseUrl = '/api/products/';

  static Future<http.StreamedResponse> addProduct(
      String token, Product item) async {
    final http.MultipartRequest multipartReq = http.MultipartRequest(
      "POST",
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: baseUrl,
      ),
    );

    multipartReq.headers['Content-Type'] = 'multipart/formdata';
    multipartReq.headers['Authorization'] = 'Bearer $token';

    multipartReq.fields['title'] = item.title;

    if (item.description != null) {
      multipartReq.fields['description'] = item.description!;
    }

    multipartReq.fields['price'] = item.price.toString();

    multipartReq.fields['stock'] = item.stock.toString();

    final http.MultipartFile img = await http.MultipartFile.fromPath(
      'image',
      item.imgFile!.path,
      contentType: MediaType('image', 'jpeg'),
    );

    if (item.imgFile != null) {
      multipartReq.files.add(img);
    }

    return multipartReq.send();
  }

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
