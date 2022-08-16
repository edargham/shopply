import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class Products with ChangeNotifier {
  List<Product> _items = <Product>[];

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

  Future<void> getProducts() {
    return ProductService.getProducts().then((Response res) {
      final Map<String, dynamic> data = json.decode(res.body);
      final List<Product> loadedItems = [];
      data.forEach((itemId, itemDetails) {
        loadedItems.add(Product(
          id: itemId,
          title: itemDetails['title'],
          description: itemDetails['description'],
          imageUrl: itemDetails['itemUrl'],
          price: itemDetails['price'],
          isFavorite: itemDetails['isFavorite'],
        ));
      });
      _items = loadedItems;
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
