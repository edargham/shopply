import 'package:flutter/foundation.dart';

import '../models/view_models/cart.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  int get cartSize {
    return _cart.length;
  }

  double get totalPrice {
    double sum = 0.0;
    for (CartItem item in _cart.values) {
      sum += item.price;
    }
    return sum;
  }

  void addItem(String productId, double price, String title) {
    if (_cart.containsKey(productId)) {
      _cart.update(
        productId,
        (CartItem existingValue) => CartItem(
          id: existingValue.id,
          title: existingValue.title,
          quantity: existingValue.quantity + 1,
          price: (existingValue.quantity + 1) * price,
        ),
      );
    } else {
      _cart.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  void deleteItem(String productId) {
    if (_cart.containsKey(productId)) {
      _cart.remove(productId);
    }
    notifyListeners();
  }

  void deleteSingleItem(String productId) {
    if (!_cart.containsKey(productId)) {
      return;
    }
    if (_cart[productId]!.quantity > 1) {
      _cart.update(
        productId,
        (CartItem value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity - 1,
        ),
      );
    } else {
      _cart.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _cart = {};
    notifyListeners();
  }
}
