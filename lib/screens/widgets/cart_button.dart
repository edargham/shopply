import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping_cart_screen/shopping_cart_screen.dart';

import '../../models/cart.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        8.0,
        0.0,
        8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: <Widget>[
              const Icon(Icons.shopping_cart),
              Consumer<Cart>(
                builder: (_, cart, __) => Text(
                  cart.cartSize.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
