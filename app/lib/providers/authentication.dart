import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../models/register_response.dart';
import '../services/auth_service.dart';

class Authentication with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String _userId;

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
      print(response);
      return parsed;
    }));
  }

  Future<void> login(String email, String password) async {
    return await AuthService.login(email, password).then((Response res) {
      print(json.decode(res.body));
    });
  }
}
