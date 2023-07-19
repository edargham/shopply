import '../view_models/product.dart';

class ProductsResponse {
  int? status;
  String? message;
  String? route;
  List<Product>? products;

  static ProductsResponse fromJson(dynamic jsonBody) {
    ProductsResponse res = ProductsResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['products'] != null) {
      Iterable products = jsonBody['products'];
      res.products = List<Product>.from(
        products.map((p) => Product.fromJson(p)),
      );
    }
    return res;
  }
}
