import '../view_models/validation_error.dart';

class UpdatePasswordResponse {
  int? status;
  String? message;
  String? route;
  List<ValidationError>? errors;

  static UpdatePasswordResponse fromJson(dynamic jsonBody) {
    UpdatePasswordResponse res = UpdatePasswordResponse();

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
