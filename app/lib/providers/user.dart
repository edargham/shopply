import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/user_service.dart';

import '../models/view_models/user.dart' as models;

class User extends ChangeNotifier {
  models.User? _currentUser;
  models.User? get currentUser => _currentUser;

  Future<void> getUser(String token, String username) {
    return UserService.getUserInformation(token, username).then((Response res) {
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        models.User response = models.User.fromJson(data);
        _currentUser = response;
        notifyListeners();
      } else {
        _currentUser = null;
        notifyListeners();
      }
    });
  }
}
