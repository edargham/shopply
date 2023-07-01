import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/view_models/cart.dart';
import '../models/view_models/order.dart';

import './utils/common.dart';

class OrderService {
  static const String _baseUrl = '/api/orders';

  static Future<http.Response> addOrder(OrderItem order, String token) {
    return http.post(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: _baseUrl,
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'amountPaid': order.amount,
        'status': OrderStatus.Pending.index,
        'cartItems': order.products
            .map(
              (CartItem item) => {
                'productId': item.productId,
                'price': item.price,
                'quantity': item.quantity
              },
            )
            .toList(),
      }),
    );
  }

  static Future<http.Response> getOrders(String token, String username,
      {OrderStatus? status}) {
    if (status != null) {
      return http.get(
        Uri(
            scheme: serverConfig['scheme'],
            host: serverConfig['host'],
            port: serverConfig['port'],
            path: '$_baseUrl/$username',
            queryParameters: {'status': status.index}),
        headers: generateHeader(token: token),
      );
    } else {
      return http.get(
        Uri(
          scheme: serverConfig['scheme'],
          host: serverConfig['host'],
          port: serverConfig['port'],
          path: '$_baseUrl/$username',
        ),
        headers: generateHeader(token: token),
      );
    }
  }
}
