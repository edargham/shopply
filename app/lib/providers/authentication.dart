import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/responses/register_response.dart';
import '../models/responses/login_response.dart';

import '../services/auth_service.dart';

class Authentication with ChangeNotifier {
  String? _token;
  // DateTime _expiryDate;
  // String _userId;

  set token(String? token) {
    _token = token;
    notifyListeners();
  }

  String? get token {
    return _token;
  }

  Future<RegisterResponse> registerUser(
    String username,
    String firstName,
    String? middleName,
    String lastName,
    String dateOfBirth,
    bool sex,
    String email,
    String phoneNumber,
    String password,
  ) async {
    return await AuthService.registerUser(
      username,
      firstName,
      middleName,
      lastName,
      dateOfBirth,
      sex,
      email,
      phoneNumber,
      password,
    ).then(((Response res) {
      final dynamic response = json.decode(res.body);
      RegisterResponse parsed = RegisterResponse.fromJson(response);
      return parsed;
    }));
  }

  Future<LoginResponse> login(String username, String password) async {
    return await AuthService.login(username, password).then((Response res) {
      final dynamic response = json.decode(res.body);
      LoginResponse parsed = LoginResponse.fromJson(response);

      if (parsed.token != null) {
        token = parsed.token;
      }

      return parsed;
    });
  }
}
