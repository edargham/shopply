import '../view_models/validation_error.dart';

class LikeResponse {
  int? status;
  String? message;
  String? route;
  bool? like;
  List<ValidationError>? errors;

  static LikeResponse fromJson(dynamic jsonBody) {
    LikeResponse res = LikeResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }

    if (jsonBody['like'] != null) {
      res.like = jsonBody['like'];
    }
    return res;
  }
}
