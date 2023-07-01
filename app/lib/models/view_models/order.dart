import 'cart.dart';

enum OrderStatus {
  Pending,
  Processing,
  Delivering,
  Completed,
}

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime? dateOrdered;
  final OrderStatus? status;

  const OrderItem({
    this.id,
    required this.amount,
    required this.products,
    this.dateOrdered,
    this.status,
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
      status: jsonBody['_status'],
    );
  }
}
