class CartItem {
  final String id;
  final String productId;
  final String? title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.quantity,
    required this.productId,
    this.title,
    this.price = 0.0,
  });

  static CartItem fromJson(dynamic jsonBody) {
    return CartItem(
      id: jsonBody['id'],
      productId: jsonBody['productId'],
      title: jsonBody['title'],
      quantity: jsonBody['quantity'],
      price: jsonBody['price'],
    );
  }
}
