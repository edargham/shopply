import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication.dart';
import '../../providers/cart.dart';
import '../../providers/order.dart';

import '../auth_screen/auth_screen.dart';
import '../widgets/item_banner.dart';
import '../widgets/item_button.dart';
import '../widgets/main_button.dart';
import './widgets/total_banner.dart';

class ShoppingCartScreen extends StatelessWidget {
  static const String routeName = '/shopping_cart';
  const ShoppingCartScreen({super.key});

  Widget _showCart(BuildContext context, Cart cart) {
    if (cart.cartSize == 0) {
      return Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.remove_shopping_cart,
                size: 64.0,
                color: Theme.of(context).colorScheme.surface,
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

  Widget _showOrderPrompt(BuildContext context, Cart cart, String? token) {
    return (token != null)
        ? MainButton(
            onPressed: () async {
              try {
                await Provider.of<Order>(
                  context,
                  listen: false,
                ).addOrder(cart.cart.values.toList(), cart.totalPrice, token);
                cart.clear();
              } catch (_) {
                // TODO - Make this global.
                await showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text(
                        'Shopply',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                          'We encountered an error while processing your request.'
                          '\nPlease try again later.'),
                      actions: [
                        ItemButton(
                          icon: Icons.check,
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            title: 'Checkout',
            icon: Icons.shopping_cart_checkout_outlined,
            color: Colors.amber,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'You must be logged in in order to perform this action.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              MainButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AuthScreen.routeName);
                },
                title: 'LOGIN',
                icon: Icons.login,
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final String? token = Provider.of<Authentication>(context).token;

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
          _showCart(context, cart),
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
                _showOrderPrompt(context, cart, token),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
