import 'dart:convert';

class User {
  String username;
  String firstName;
  String? middleName;
  String lastName;
  DateTime dateOfBirth;
  String sex;
  String email;
  String? phoneNumber;
  DateTime dateJoined;
  String? profilePhotoUrl;
  bool isVerified;

  User({
    required this.username,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.dateOfBirth,
    required this.sex,
    required this.email,
    this.phoneNumber,
    required this.dateJoined,
    this.profilePhotoUrl,
    required this.isVerified,
  });

  static User fromJson(dynamic jsonBody) {
    return User(
      username: jsonBody['username'],
      firstName: jsonBody['firstName'],
      middleName: jsonBody['middleName'],
      lastName: jsonBody['lastName'],
      dateOfBirth: DateTime.parse(jsonBody['dateOfBirth']),
      sex: jsonBody['sex'] ? 'Male' : 'Female',
      email: jsonBody['email'],
      phoneNumber: jsonBody['phoneNumber'],
      dateJoined: DateTime.parse(jsonBody['dateJoined']),
      profilePhotoUrl: (jsonBody['profilePhotoUrl'] != null)
          ? 'http://10.0.2.2:3000/${jsonBody['profilePhotoUrl']}'
          : null,
      isVerified: jsonBody['isVerified'],
    );
  }

  static User patchJson(dynamic jsonBody, User user) {
    return User(
      username: jsonBody['username'],
      firstName: jsonBody['firstName'],
      middleName: jsonBody['middleName'],
      lastName: jsonBody['lastName'],
      dateOfBirth: user.dateOfBirth,
      sex: user.sex,
      email: user.email,
      phoneNumber: user.phoneNumber,
      dateJoined: user.dateJoined,
      profilePhotoUrl: user.profilePhotoUrl,
      isVerified: user.isVerified,
    );
  }
}
