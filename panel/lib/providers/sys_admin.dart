import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/responses/update_email_response.dart';
import '../services/sys_admin_service.dart';

import '../models/responses/update_sys_admin_response.dart';
import '../models/responses/update_password_response.dart';
import '../models/view_models/sys_admin.dart' as models;

class SysAdmin extends ChangeNotifier {
  models.SysAdmin? _currentUser;
  models.SysAdmin? get currentUser => _currentUser;

  Future<void> getUser(String token, String username) {
    return SysAdminService.getUserInformation(token, username)
        .then((Response res) {
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        models.SysAdmin response = models.SysAdmin.fromJson(data);
        _currentUser = response;
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  Future<UpdateSysAdminResponse> updateUser(
    String token,
    String username,
    String firstName,
    String lastName,
  ) async {
    return await SysAdminService.updateUserInformation(
      token,
      username,
      firstName,
      lastName,
    ).then((res) {
      if (res.statusCode == 200) {
        _currentUser!.firstName = firstName;
        _currentUser!.lastName = lastName;

        notifyListeners();
      }

      return UpdateSysAdminResponse.fromJson(
          json.decode(res.body), _currentUser!);
    });
  }

  Future<UpdateEmailResponse> updateEmail(
    String token,
    String username,
    String email,
  ) async {
    return await SysAdminService.updateEmail(
      token,
      username,
      email,
    ).then((res) {
      if (res.statusCode == 200) {
        _currentUser!.email = email;

        notifyListeners();
      }

      return UpdateEmailResponse.fromJson(jsonDecode(res.body));
    });
  }

  Future<UpdatePasswordResponse> updatePassword(
    String token,
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    return await SysAdminService.updatePassword(
      token,
      username,
      oldPassword,
      newPassword,
    ).then((res) {
      return UpdatePasswordResponse.fromJson(jsonDecode(res.body));
    });
  }
}
