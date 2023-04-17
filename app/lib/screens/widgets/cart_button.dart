import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shopping_cart_screen/shopping_cart_screen.dart';

import '../../models/view_models/cart.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ShoppingCartScreen.routeName);
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        height: 48,
        width: 48,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background.withOpacity(0.64),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.shopping_cart,
                size: 20.0,
              ),
              Consumer<Cart>(
                builder: (_, cart, __) => Text(
                  cart.cartSize.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
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
