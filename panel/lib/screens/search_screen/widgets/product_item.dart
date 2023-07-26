import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/item_button.dart';

import '../../auth_screen/auth_screen.dart';

import '../../../providers/authentication.dart';
import '../../../providers/cart.dart';

import '../../../models/view_models/product.dart';

import '../../product_details_screen/product_details_screen.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final double _radius = 8.0;
  bool _isLoading = false;

  void _onProductPressed(BuildContext context, Product item) {
    Navigator.of(context).pushNamed(
      ProductDetailsScreen.routeName,
      arguments: {
        'productId': item.id,
      },
    );
  }

  Widget _showImage(Product item) {
    // try {
    return Expanded(
      flex: 2,
      child: Image.network(
        item.imageUrl!,
        fit: BoxFit.fill,
      ),
    );
    // } catch (_) {
    // return const Expanded(
    //   flex: 2,
    //   child: Center(
    //     child: Text('Image not available.'),
    //   ),
    // );
    // }
  }

  Future<void> _showAuthDialog() {
    return showDialog(
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
              'You must be logged in in order to perform this action.'),
          actions: [
            ItemButton(
              icon: Icons.close,
              color: Theme.of(context).colorScheme.error,
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ItemButton(
              icon: Icons.login,
              onPressed: () {
                Navigator.of(ctx).popAndPushNamed(AuthScreen.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    final Product item = Provider.of<Product>(context);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final String? token = Provider.of<Authentication>(context).token;

    const double hScale = 0.32;
    return InkWell(
      onTap: () => _onProductPressed(context, item),
      borderRadius: BorderRadius.circular(_radius),
      child: Container(
        padding: const EdgeInsets.only(right: 8.0),
        margin: const EdgeInsets.all(4.0),
        height: deviceDisplay.size.height * hScale,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1.0,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.32),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background.withOpacity(0.64),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            (item.imageUrl != null) ? _showImage(item) : Container(),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            item.title,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            '\$${item.price}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            (item.stock > 0) ? 'In stock' : 'Out of stock',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ItemButton(
                              onPressed: () async {
                                if (token != null) {
                                  cart.addItem(item.id, item.price, item.title);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'x1 ${item.title} added to cart'),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.65),
                                      action: SnackBarAction(
                                          label: 'UNDO',
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          onPressed: () {
                                            cart.deleteSingleItem(item.id);
                                          }),
                                      duration:
                                          const Duration(milliseconds: 768),
                                    ),
                                  );
                                } else {
                                  await _showAuthDialog();
                                }
                              },
                              color: Colors.amber,
                              icon: Icons.add_shopping_cart,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
