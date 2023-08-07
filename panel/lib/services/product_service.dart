import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

    if (item.imgFile != null) {
      final http.MultipartFile img = await http.MultipartFile.fromPath(
        'image',
        item.imgFile!.path,
        contentType: MediaType('image', 'jpeg'),
      );
      multipartReq.files.add(img);
    }

    return multipartReq.send();
  }

  static Future<http.Response> deleteProduct(String token, String id) {
    return http.delete(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: "$baseUrl/$id",
      ),
      headers: generateHeader(token: token),
    );
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

  static Future<http.Response> updateProduct(String token, Product item) {
    return http.patch(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$baseUrl/${item.id}',
      ),
      headers: generateHeader(token: token),
      body: json.encode(
        (item.description != null)
            ? {
                'description': item.description,
                'price': item.price,
                'stock': item.stock,
              }
            : {
                'price': item.price,
                'stock': item.stock,
              },
      ),
    );
  }

  static Future<http.StreamedResponse> updateProductPhoto(
    String token,
    Product item,
  ) async {
    final http.MultipartRequest multipartReq = http.MultipartRequest(
      'PATCH',
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$baseUrl/update-photo/${item.id}',
      ),
    );
    if (item.imgFile != null) {
      final http.MultipartFile img = await http.MultipartFile.fromPath(
        'image',
        item.imgFile!.path,
        contentType: MediaType('image', 'jpeg'),
      );
      multipartReq.files.add(img);
    }

    return multipartReq.send();
  }

  static Future<File> getPhotoAsFile(String imgUrl, String title) async {
    final response = await http.get(Uri.parse(imgUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, '$title.png'));
    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}
