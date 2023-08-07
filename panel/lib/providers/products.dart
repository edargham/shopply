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
        .then((StreamedResponse res) async {
      final Response response = await Response.fromStream(res);
      final Map<String, dynamic> data = json.decode(response.body);
      AddProductResponse apResp = AddProductResponse.fromJson(data);
      if (apResp.status == 201) {
        Product savedItem = Product(
          id: apResp.product!.id,
          title: newItem.title,
          description: newItem.description,
          price: newItem.price,
          stock: newItem.stock,
          imageUrl: apResp.product!.imageUrl,
        );
        _items.add(savedItem);
        notifyListeners();
      } else {
        throw Exception(apResp.message);
      }

      return apResp;
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

  Future<void> updateProduct(String token, Product item) {
    return ProductService.updateProduct(token, item)
        .then((Response updatedDataResponse) async {
      AddProductResponse updatedProductDataResponse =
          AddProductResponse.fromJson(json.decode(updatedDataResponse.body));
      if (updatedProductDataResponse.status == 200) {
        await ProductService.updateProductPhoto(token, item)
            .then((StreamedResponse res) async {
          Response resp = await Response.fromStream(res);
          AddProductResponse finalResponse =
              AddProductResponse.fromJson(json.decode(resp.body));

          if (finalResponse.status == 200) {
            item = finalResponse.product!;
            int index = _items.indexWhere((Product itm) => item.id == itm.id);
            _items[index] = item;
            notifyListeners();
          } else {
            throw finalResponse.message!;
          }
        });
      } else {
        throw updatedProductDataResponse.message!;
      }
    });
  }

  Future<void> deleteProduct(String token, Product item) {
    final int itemIdx = _items.indexWhere((Product p) => item.id == p.id);
    Product? itemToRemove = _items[itemIdx];
    _items.removeAt(itemIdx);
    return ProductService.deleteProduct(token, item.id).then((Response res) {
      final AddProductResponse resp =
          AddProductResponse.fromJson(json.decode(res.body));

      if (resp.status == 200) {
        notifyListeners();
        itemToRemove = null;
      } else {
        throw resp.message!;
      }
    }).catchError((error) {
      _items.insert(itemIdx, itemToRemove!);
      notifyListeners();
      throw error;
    });
  }

  Product findProductById(String productId) {
    return items.firstWhere((Product itm) => productId == itm.id);
  }
}
