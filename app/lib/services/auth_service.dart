import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
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
      headers: {'Content-Type': 'application/json'},
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

  static Future<http.Response> login(String email, String password) {
    return http.post(
      Uri(
        scheme: 'https',
        host: 'identitytoolkit.googleapis.com',
        path: '/v1/accounts:signInWithPassword',
      ),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }
}
