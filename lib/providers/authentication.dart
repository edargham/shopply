import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../services/auth_service.dart';

class Authentication with ChangeNotifier {
  // String _token;
  // DateTime _expiryDate;
  // String _userId;

  Future<void> registerUser(
      String email, String firstName, String lastName, String password) async {
    return await AuthService.registerUser(email, password)
        .then(((Response res) {
      final response = json.decode(res.body);
      return AuthService.updateDetails(
              response['idToken'], '$firstName $lastName')
          .then((_) {
        print(json.decode(res.body));
      });
    }));
  }
}
