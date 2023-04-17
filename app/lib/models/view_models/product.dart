import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../errors/http_exception.dart';
import '../../services/product_service.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String? description;
  String? imageUrl;
  double price;
  int stock;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    required this.price,
    required this.stock,
    this.isFavorite = false,
  });

  /*Future<void>*/ void setFavorite(String id, bool isFavorite) {
    // bool thisIsFavorite = this.isFavorite;

    // return ProductService.setFavorite(id, isFavorite).then((Response res) {
    //   if (res.statusCode >= 400) {
    //     throw HttpException('Could not update product $id.');
    //   }
    this.isFavorite = isFavorite;
    //   notifyListeners();
    // }).catchError((error) {
    //   this.isFavorite = thisIsFavorite;
    //   notifyListeners();
    //   throw error;
    // });
  }

  static Product fromJson(dynamic jsonBody) {
    Product res = Product(
      id: jsonBody['id'],
      title: jsonBody['title'],
      description: jsonBody['description'],
      imageUrl: jsonBody['imageUrl'],
      price: jsonBody['price'],
      stock: jsonBody['stock'],
    );

    return res;
  }
}
