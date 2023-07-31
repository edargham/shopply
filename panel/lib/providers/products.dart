import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shopply_admin_panel/models/responses/add_prooduct_response.dart';

import '../models/responses/product_response.dart';
import '../models/view_models/product.dart';

import '../services/product_service.dart';

class Products with ChangeNotifier {
  List<Product> _items = <Product>[];

  List<Product> get items {
    return [..._items];
  }

  List<Product> _searchResults = <Product>[];

  List<Product> get searchResults {
    return [..._searchResults];
  }

  Future<void> searchFor(String query, {String? token}) {
    return ProductService.searchFor(query, token: token).then((Response res) {
      final Map<String, dynamic> data = json.decode(res.body);
      ProductsResponse response = ProductsResponse.fromJson(data);

      List<Product> loadedItems = [];

      if (response.products != null) {
        loadedItems = response.products!;
      }

      _searchResults = loadedItems;
      notifyListeners();
    });
  }

  Future<AddProductResponse> addProduct(String token, Product newItem) {
    return ProductService.addProduct(token, newItem)
        .then((StreamedResponse res) {
      final Map<String, dynamic> data = json.decode(res.stream);
      AddProductResponse response = AddProductResponse.fromJson(data);
      if (response.status == 201) {
        Product savedItem = Product(
          id: json.decode(res.body)['name'],
          title: newItem.title,
          description: newItem.description,
          price: newItem.price,
          stock: newItem.stock,
          imageUrl: newItem.imageUrl,
        );
        _items.add(savedItem);
        notifyListeners();
      } else {
        throw Exception(response.message);
      }

      return response;
    });
  }

  Future<void> getProducts({String? token}) {
    return ProductService.getProducts(token: token).then((Response res) {
      final Map<String, dynamic> data = json.decode(res.body);
      ProductsResponse response = ProductsResponse.fromJson(data);

      List<Product> loadedItems = [];

      if (response.products != null) {
        loadedItems = response.products!;
      }

      _items = loadedItems;
      notifyListeners();
    });
  }
  // Future<void> updateProduct(Product item) {
  //   return ProductService.updateProduct(item).then((_) {
  //     int index = _items.indexWhere((Product itm) => item.id == itm.id);
  //     _items[index] = item;
  //     notifyListeners();
  //   });
  // }

  // Future<void> deleteProduct(Product item) {
  //   final int itemIdx = _items.indexWhere((Product p) => item.id == p.id);
  //   Product? itemToRemove = _items[itemIdx];
  //   _items.removeAt(itemIdx);
  //   return ProductService.deleteProduct(item).then((Response res) {
  //     if (res.statusCode >= 400) {
  //       throw HttpException('Delete failed.');
  //     }
  //     notifyListeners();
  //     itemToRemove = null;
  //   }).catchError((error) {
  //     _items.insert(itemIdx, itemToRemove!);
  //     notifyListeners();
  //     throw error;
  //   });
  // }

  Product findProductById(String productId) {
    return items.firstWhere((Product itm) => productId == itm.id);
  }
}
