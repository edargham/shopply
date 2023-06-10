import '../view_models/validation_error.dart';

class UpdateEmailResponse {
  int? status;
  String? message;
  String? route;
  List<ValidationError>? errors;

  static UpdateEmailResponse fromJson(dynamic jsonBody) {
    UpdateEmailResponse res = UpdateEmailResponse();

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
