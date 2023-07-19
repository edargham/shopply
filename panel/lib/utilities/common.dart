import 'dart:io' show Platform;

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

const Map<String, dynamic> serverConfigAndroid = {
  'scheme': 'http',
  'host': '10.0.2.2',
  'port': 3000
};

const Map<String, dynamic> serverConfigApple = {
  'scheme': 'http',
  'host': '127.0.0.1',
  'port': 3000
};

final Map<String, dynamic> serverConfig =
    (Platform.isAndroid) ? serverConfigAndroid : serverConfigApple;
