import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart.dart';

import '../shopping_cart_screen/widgets/item_banner.dart';

import '../widgets/main_button.dart';
import './widgets/total_banner.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const String routeName = '/shopping_cart';
  const ShoppingCartScreen({super.key});

  Widget _showCart(Cart cart) {
    if (cart.cartSize == 0) {
      return const Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Text('Wow! Such Empty...'),
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: cart.cartSize,
            itemBuilder: (context, index) {
              return ItemBanner(
                item: cart.cart.values.toList()[index],
                productId: cart.cart.keys.toList()[index],
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

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
        children: <Widget>[
          _showCart(cart),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TotalBanner(
                    totalPrice: cart.totalPrice,
                  ),
                ),
                MainButton(
                  onPressed: () {},
                  title: 'Checkout',
                  icon: Icons.shopping_cart_checkout_outlined,
                  color: Colors.amber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
