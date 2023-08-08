import 'package:http/http.dart' as http;

import '../models/view_models/order.dart';

import '../utilities/common.dart';

class OrderService {
  static const String _baseUrl = '/api/orders';

  static Future<http.Response> getOrders(String token, String username,
      {OrderStatus? status}) {
    if (status != null) {
      return http.get(
        Uri(
            scheme: serverConfig['scheme'],
            host: serverConfig['host'],
            port: serverConfig['port'],
            path: _baseUrl,
            queryParameters: {'status': status.index}),
        headers: generateHeader(token: token),
      );
    } else {
      return http.get(
        Uri(
          scheme: serverConfig['scheme'],
          host: serverConfig['host'],
          port: serverConfig['port'],
          path: _baseUrl,
        ),
        headers: generateHeader(token: token),
      );
    }
  }
}
