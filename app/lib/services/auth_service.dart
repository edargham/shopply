import 'dart:convert';

import 'package:http/http.dart' as http;

import './utils/common.dart';

class AuthService {
  static const String _baseUrl = '/api/users';
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
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/signup',
      ),
      headers: generateHeader(),
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
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/login',
      ),
      headers: generateHeader(),
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
  }
}
