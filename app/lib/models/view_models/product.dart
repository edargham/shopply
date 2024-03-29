import 'package:flutter/material.dart';

import '../../utilities/common.dart';

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

  void setFavorite(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  static Product fromJson(dynamic jsonBody) {
    bool liked = false;

    if (jsonBody['liked'] != null) {
      liked = jsonBody['liked'];
    }

    Product res = Product(
      id: jsonBody['id'],
      title: jsonBody['title'],
      description: jsonBody['description'],
      imageUrl:
          '${serverConfig['scheme']}://${serverConfig['host']}:${serverConfig['port']}/${jsonBody['imageUrl']}',
      price: jsonBody['price'],
      stock: jsonBody['stock'],
      isFavorite: liked,
    );

    return res;
  }
}
