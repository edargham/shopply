import 'dart:convert';

import 'package:http/http.dart' as http;
import '../private/config.dart';

class AuthService {
  static Future<http.Response> registerUser(String email, String password) {
    return http.post(
      Uri(
        scheme: 'https',
        host: 'identitytoolkit.googleapis.com',
        path: '/v1/accounts:signUp',
        query: 'key=$apiKey',
      ),
      // Uri.https(registerUrl, ''),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }

  static Future<http.Response> updateDetails(String idToken, String fullName) {
    return http.post(
      Uri(
        scheme: 'https',
        host: 'identitytoolkit.googleapis.com',
        path: '/v1/accounts:signUp',
        query: 'key=$apiKey',
      ),
      // Uri.https(registerUrl, ''),
      body: json.encode({
        'idToken': idToken,
        'displayName': fullName,
        'returnSecureToken': true,
      }),
    );
  }
}
