import 'dart:convert';

class ValidationError {
  String msg;
  String param;
  String location;

  ValidationError({
    required this.msg,
    required this.param,
    required this.location,
  });

  static ValidationError fromJson(dynamic jsonBody) {
    ValidationError res = ValidationError(
      msg: jsonBody['msg'],
      param: jsonBody['param'],
      location: jsonBody['location'],
    );

    return res;
  }
}
