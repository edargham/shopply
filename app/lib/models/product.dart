import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../errors/http_exception.dart';
import '../services/product_service.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> setFavorite(String id, bool isFavorite) {
    bool thisIsFavorite = this.isFavorite;

    return ProductService.setFavorite(id, isFavorite).then((Response res) {
      if (res.statusCode >= 400) {
        throw HttpException('Could not update product $id.');
      }
      this.isFavorite = isFavorite;
      notifyListeners();
    }).catchError((error) {
      this.isFavorite = thisIsFavorite;
      notifyListeners();
      throw error;
    });
  }
}
