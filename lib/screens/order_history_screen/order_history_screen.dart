import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';

import './widgets/order_banner.dart';

import '../tab_navigation_screen/widgets/main_drawer.dart';

class OrderHistoryScreen extends StatelessWidget {
  static const String routeName = '/order_history';
  const OrderHistoryScreen({super.key});

  Widget _showOrders(BuildContext context, Order order) {
    if (order.orders.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.history,
              size: 64.0,
              color: Colors.amber,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                child: Text(
                  'Wow! Such Empty... Perhaps wanna go shopping?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: order.orders.length,
          itemBuilder: (context, index) {
            return OrderBanner(
              item: order.orders[index],
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Order order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Previous Orders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      drawer: const MainDrawer(),
      body: _showOrders(context, order),
    );
  }
}
