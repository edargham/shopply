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

  static CartItem fromJson(dynamic jsonBody) {
    return CartItem(
      id: jsonBody['id'],
      title: jsonBody['title'],
      quantity: jsonBody['quantity'],
      price: jsonBody['price'],
    );
  }
}
