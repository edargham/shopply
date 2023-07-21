import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/view_models/order.dart';

import '../models/responses/get_orders_response.dart';

import '../../services/order_service.dart';

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders => [..._orders];

  Future<void> getOrders(String token, String username, {OrderStatus? status}) {
    return OrderService.getOrders(
      token,
      username,
      status: status,
    ).then((Response res) {
      GetOrdersResponse data =
          GetOrdersResponse.fromJson(json.decode(res.body));
      if (res.statusCode == 200 && data.orders != null) {
        final List<OrderItem> loadedOrders = data.orders!;

        _orders = loadedOrders;
        notifyListeners();
      } else {
        _orders = [];
        throw data;
      }
    }).catchError((error) {
      _orders = [];
      throw error;
    });
  }

  /*Future<void>*/ void deleteOder(String orderId) {
    // final int itemIdx = _orders.indexWhere((OrderItem o) => orderId == o.id);
    // OrderItem? itemToRemove = _orders[itemIdx];
    // _orders.removeAt(itemIdx);
    // return OrderService.deleteOrder(orderId).then((Response res) {
    //   if (res.statusCode >= 400) {
    //     throw HttpException('Delete failed.');
    //   }
    //   notifyListeners();
    //   itemToRemove = null;
    // }).catchError((error) {
    //   _orders.insert(itemIdx, itemToRemove!);
    //   notifyListeners();
    //   throw error;
    // });
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
