import 'dart:convert';

import 'cart.dart';

enum OrderStatus {
  // ignore: constant_identifier_names
  Pending,
  // ignore: constant_identifier_names
  Processing,
  // ignore: constant_identifier_names
  Delivering,
  // ignore: constant_identifier_names
  Completed,
}

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime? dateOrdered;
  final OrderStatus? status;
  final String? username;

  const OrderItem({
    this.id,
    required this.amount,
    required this.products,
    this.dateOrdered,
    this.status,
    this.username,
  });

  static OrderItem fromJson(dynamic jsonBody) {
    Iterable jProducts = jsonBody['_items'];
    List<CartItem> products = List<CartItem>.from(
      jProducts.map((ci) => CartItem.fromJson(ci)),
    );

    return OrderItem(
      id: jsonBody['_id'],
      amount: jsonBody['_amountPaid'],
      products: products,
      dateOrdered: DateTime.parse(jsonBody['_dateOrdered']),
      username: jsonBody['_username'],
      status: OrderStatus.values
          .where((status) => status.index == (jsonBody['_statusId'] - 1))
          .first,
    );
  }
}
