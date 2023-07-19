import '../view_models/order.dart';
import '../view_models/validation_error.dart';

class GetOrdersResponse {
  int? status;
  String? message;
  String? route;
  List<OrderItem>? orders;
  List<ValidationError>? errors;

  static GetOrdersResponse fromJson(dynamic jsonBody) {
    GetOrdersResponse res = GetOrdersResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }

    if (jsonBody['orders'] != null) {
      Iterable orders = jsonBody['orders'];
      res.orders = List<OrderItem>.from(
        orders.map((p) => OrderItem.fromJson(p)),
      );
    }
    return res;
  }
}
