import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/view_models/cart.dart';
import '../models/view_models/order.dart';

class OrderService {
  static const String _ordersUrl = '/orders.json';
  static const String _ordersRoute = '/orders';

  static Future<http.Response> addOrder(OrderItem order) {
    return http.post(
      Uri.https('10.0.2.2', _ordersUrl),
      body: json.encode({
        'amount': order.amount,
        'dateOrdered': order.dateOrdered.toIso8601String(),
        'products': order.products
            .map(
              (CartItem item) => {
                'id': item.id,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity
              },
            )
            .toList(),
      }),
    );
  }

  static Future<http.Response> getOrders() {
    return http.get(Uri.https('10.0.2.2', _ordersUrl));
  }

  static Future<http.Response> deleteOrder(String id) {
    return http.delete(Uri.http('10.0.2.2', '$_ordersRoute/$id.json'));
  }
}
