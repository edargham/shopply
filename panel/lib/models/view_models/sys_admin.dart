class SysAdmin {
  String username;
  String firstName;
  String lastName;
  String email;
  String? phoneNumber;

  SysAdmin({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
  });

  static SysAdmin fromJson(dynamic jsonBody) {
    return SysAdmin(
      username: jsonBody['username'],
      firstName: jsonBody['firstName'],
      lastName: jsonBody['lastName'],
      email: jsonBody['email'],
      phoneNumber: jsonBody['phoneNumber'],
    );
  }

  static SysAdmin patchJson(dynamic jsonBody, SysAdmin user) {
    return SysAdmin(
      username: jsonBody['username'],
      firstName: jsonBody['firstName'],
      lastName: jsonBody['lastName'],
      email: user.email,
      phoneNumber: user.phoneNumber,
    );
  }
}
