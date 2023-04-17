import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const Map<String, String> _header = {
    'Content-Type': 'application/json'
  };

  static Future<http.Response> registerUser(
    String username,
    String firstName,
    String? middleName,
    String lastName,
    String dateOfBirth,
    bool sex,
    String email,
    String phoneNumber,
    String password,
  ) {
    return http.post(
      Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 3000,
        path: '/api/users/signup',
      ),
      headers: _header,
      // Uri.https(registerUrl, ''),
      body: (middleName != null)
          ? json.encode({
              'username': username,
              'firstName': firstName,
              'middleName': middleName,
              'lastName': lastName,
              'dateOfBirth': dateOfBirth,
              'sex': sex,
              'email': email,
              'phoneNumber': phoneNumber,
              'password': password
            })
          : json.encode({
              'username': username,
              'firstName': firstName,
              'lastName': lastName,
              'dateOfBirth': dateOfBirth,
              'sex': sex,
              'email': email,
              'phoneNumber': phoneNumber,
              'password': password
            }),
    );
  }

  static Future<http.Response> login(String username, String password) {
    return http.post(
      Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 3000,
        path: '/api/users/login',
      ),
      headers: _header,
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
  }
}
