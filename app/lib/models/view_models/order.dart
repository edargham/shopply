import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../errors/http_exception.dart';
import 'cart.dart';
import '../../services/order_service.dart';

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

      data.forEach((key, value) {
        loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          dateOrdered: DateTime.parse(value['dateOrdered']),
          products: (value['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }).catchError((error) {
      _orders = [];
      throw error;
    });
  }

  Future<void> deleteOder(String orderId) {
    final int itemIdx = _orders.indexWhere((OrderItem o) => orderId == o.id);
    OrderItem? itemToRemove = _orders[itemIdx];
    _orders.removeAt(itemIdx);
    return OrderService.deleteOrder(orderId).then((Response res) {
      if (res.statusCode >= 400) {
        throw HttpException('Delete failed.');
      }
      notifyListeners();
      itemToRemove = null;
    }).catchError((error) {
      _orders.insert(itemIdx, itemToRemove!);
      notifyListeners();
      throw error;
    });
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
