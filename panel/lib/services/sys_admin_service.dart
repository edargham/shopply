import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utilities/common.dart';

class SysAdminService {
  static const String _baseUrl = '/api/sysadmins';

  static Future<http.Response> getUserInformation(
      String token, String username) {
    return http.get(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/$username',
      ),
      headers: generateHeader(token: token),
    );
  }

  static Future<http.Response> updateUserInformation(
    String token,
    String username,
    String firstName,
    String lastName,
  ) {
    return http.patch(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/$username',
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
      }),
    );
  }

  static Future<http.Response> updateEmail(
    String token,
    String username,
    String email,
  ) {
    return http.patch(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/change-email/$username',
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'email': email,
      }),
    );
  }

  static Future<http.Response> updatePassword(
    String token,
    String username,
    String oldPassword,
    String password,
  ) {
    return http.patch(
      Uri(
        scheme: serverConfig['scheme'],
        host: serverConfig['host'],
        port: serverConfig['port'],
        path: '$_baseUrl/change-password/$username',
      ),
      headers: generateHeader(token: token),
      body: json.encode({
        'oldPassword': oldPassword,
        'password': password,
      }),
    );
  }
}
