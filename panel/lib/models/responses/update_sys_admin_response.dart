import '../view_models/sys_admin.dart';
import '../view_models/validation_error.dart';

class UpdateSysAdminResponse {
  int? status;
  String? message;
  String? route;
  List<ValidationError>? errors;
  SysAdmin? user;

  static UpdateSysAdminResponse fromJson(
      dynamic jsonBody, SysAdmin currentUser) {
    UpdateSysAdminResponse res = UpdateSysAdminResponse();

    res.status = jsonBody['status'];
    res.message = jsonBody['message'];
    res.route = jsonBody['route'];

    if (jsonBody['errors'] != null) {
      Iterable errs = jsonBody['errors'];
      res.errors = List<ValidationError>.from(
          errs.map((err) => ValidationError.fromJson(err)));
    }

    if (jsonBody['user'] != null) {
      res.user = SysAdmin.patchJson(jsonBody['user'], currentUser);
    }

    return res;
  }
}
