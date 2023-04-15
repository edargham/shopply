import 'validation_error.dart';

class RegisterResponse {
  int? status;
  String? message;
  String? route;
  List<ValidationError>? errors;

  static RegisterResponse fromJson(dynamic jsonBody) {
    RegisterResponse res = RegisterResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }
    return res;
  }
}
