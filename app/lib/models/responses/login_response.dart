import '../view_models/validation_error.dart';

class LoginResponse {
  int? status;
  String? message;
  String? token;
  String? route;
  List<ValidationError>? errors;

  static LoginResponse fromJson(dynamic jsonBody) {
    LoginResponse res = LoginResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.token = jsonBody['token'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }
    return res;
  }
}
