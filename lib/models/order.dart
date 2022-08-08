import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateOrdered;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateOrdered,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => [..._orders];

  void addOrder(List<CartItem> cart, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: 'o${DateTime.now().toString()}',
        amount: total,
        products: cart,
        dateOrdered: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
