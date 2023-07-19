import '../view_models/user.dart';
import '../view_models/validation_error.dart';

class UpdateUserResponse {
  int? status;
  String? message;
  String? route;
  List<ValidationError>? errors;
  User? user;

  static UpdateUserResponse fromJson(dynamic jsonBody, User currentUser) {
    UpdateUserResponse res = UpdateUserResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }

    if (jsonBody['user'] != null) {
      res.user = User.patchJson(jsonBody['user'], currentUser);
    }

    return res;
  }
}
