import '../view_models/order.dart';
import '../view_models/validation_error.dart';

class SubmitOrderResponse {
  int? status;
  String? message;
  String? route;
  OrderItem? order;
  List<ValidationError>? errors;

  static SubmitOrderResponse fromJson(dynamic jsonBody) {
    SubmitOrderResponse res = SubmitOrderResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }

    if (jsonBody['order'] != null) {
      res.order = OrderItem.fromJson(jsonBody['order']);
    }
    return res;
  }
}
