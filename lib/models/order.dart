import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import './cart.dart';
import '../services/order_service.dart';

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

  Future<void> addOrder(List<CartItem> cart, double total) {
    OrderItem orderToAdd = OrderItem(
      id: 'o${DateTime.now().toString()}',
      amount: total,
      products: cart,
      dateOrdered: DateTime.now(),
    );
    return OrderService.addOrder(orderToAdd).then((Response res) {
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cart,
          dateOrdered: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }

  void deleteOder(String orderId) {
    _orders.removeWhere((OrderItem order) => order.id == orderId);
    notifyListeners();
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
