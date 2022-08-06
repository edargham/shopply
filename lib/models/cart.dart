import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    this.price = 0.0,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cart {
    return {..._cart};
  }

  int get cartSize {
    return _cart.length;
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
}
