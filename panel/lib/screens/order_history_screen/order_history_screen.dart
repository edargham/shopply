import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/sys_admin.dart' as model;

import '../../providers/authentication.dart';
import '../../providers/sys_admin.dart';
import '../../providers/order.dart';

import './widgets/order_banner.dart';

import '../widgets/main_drawer.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const String routeName = '/order_history';
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = false;
  bool _init = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      final model.SysAdmin? currentUser =
          Provider.of<SysAdmin>(context).currentUser;
      final String? token = Provider.of<Authentication>(context).token;

      Provider.of<Order>(context, listen: false)
          .getOrders(token!, currentUser!.username)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        _init = false;
      }).catchError((e) {
        throw e;
        // TODO - Display error.
      });
    }

    super.didChangeDependencies();
  }

  Widget _showOrders(BuildContext context, Order order) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.background,
        ),
      );
    }

    if (order.orders.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.assignment,
              size: 64.0,
              color: Colors.amber,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
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
          'Your Orders',
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
