import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class Products with ChangeNotifier {
  final List<Product> _items = <Product>[
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product newItem) {
    return ProductService.addProduct(newItem).then((Response res) {
      Product savedItem = Product(
        id: json.decode(res.body)['name'],
        title: newItem.title,
        description: newItem.description,
        price: newItem.price,
        imageUrl: newItem.imageUrl,
        isFavorite: newItem.isFavorite,
      );
      _items.add(savedItem);
      notifyListeners();
    });
  }

  void updateProduct(Product item) {
    int index = _items.indexWhere((Product itm) => item.id == itm.id);
    _items[index] = item;
    notifyListeners();
  }

  void deleteProduct(Product item) {
    _items.removeWhere((Product itm) => item.id == itm.id);
    notifyListeners();
  }

  Product findProductById(String productId) {
    return items.firstWhere((Product itm) => productId == itm.id);
  }
}
