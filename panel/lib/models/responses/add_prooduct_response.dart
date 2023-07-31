import '../view_models/product.dart';

class AddProductResponse {
  int? status;
  String? message;
  String? route;
  Product? product;

  static AddProductResponse fromJson(dynamic jsonBody) {
    AddProductResponse res = AddProductResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['product'] != null) {
      res.product = Product.fromJson(jsonBody['product']);
    }
    return res;
  }
}
