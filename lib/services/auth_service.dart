import 'dart:convert';

import 'package:http/http.dart' as http;
import '../private/config.dart';

class AuthService {
  static Future<http.Response> registerUser(String email, String password) {
    String registerUrl = 'identitytoolkit.googleapis.com';
    return http.post(
      Uri.https(registerUrl, '/v1/accounts:signUp?key=$apiKey'),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }
}
