Map<String, String> generateHeader({String? token}) {
  if (token != null) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  } else {
    return {
      'Content-Type': 'application/json',
    };
  }
}

const Map<String, dynamic> serverConfig = {
  'scheme': 'http',
  'host': '10.0.2.2',
  'port': 3000
};
