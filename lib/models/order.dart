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

  Future<void> getOrders() {
    return OrderService.getOrders().then((Response res) {
      final Map<String, dynamic> data = json.decode(res.body);
      final List<OrderItem> loadedOrders = [];

      List<CartItem> parseCartItems(List<Map<dynamic, dynamic>> value) {
        List<CartItem> loadedCartItems = [];

        for (Map<dynamic, dynamic> item in value) {
          loadedCartItems.add(CartItem(
            id: item['id'],
            title: item['title'],
            quantity: item['quantity'],
          ));
        }

        return loadedCartItems;
      }

      data.forEach((key, value) {
        final products = value['products'];
        loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: parseCartItems(
              (value['products'] as List<Map<dynamic, dynamic>>)),
          dateOrdered: DateTime.now(),
        ));
      });

      _orders = loadedOrders;
      notifyListeners();
    }).catchError((error) {
      _orders = [];
      throw error;
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
