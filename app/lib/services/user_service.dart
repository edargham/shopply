import 'dart:convert';

import 'package:http/http.dart' as http;

class UserService {
  static Map<String, String> _generateHeader(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Future<http.Response> getUserInformation(
      String token, String username) {
    return http.get(
      Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 3000,
        path: '/api/users/$username',
      ),
      headers: _generateHeader(token),
    );
  }

  static Future<http.Response> updateUserInformation(
    String token,
    String username,
    String firstName,
    String lastName,
    String? middleName,
  ) {
    if (middleName == null) {
      return http.patch(
          Uri(
              scheme: 'http',
              host: '10.0.2.2',
              port: 3000,
              path: '/api/users/$username'),
          headers: _generateHeader(token),
          body: json.encode({
            'firstName': firstName,
            'lastName': lastName,
          }));
    } else {
      return http.patch(
          Uri(
              scheme: 'http',
              host: '10.0.2.2',
              port: 3000,
              path: '/api/users/$username'),
          headers: _generateHeader(token),
          body: json.encode({
            'firstName': firstName,
            'middleName': middleName,
            'lastName': lastName,
          }));
    }
  }
}