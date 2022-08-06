import 'package:flutter/material.dart';

import './widgets/total_banner.dart';
// import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const String routeName = '/shopping_cart';
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text('Wow! Such Empty...'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TotalBanner(),
            ),
          ),
        ],
      ),
    );
  }
}
