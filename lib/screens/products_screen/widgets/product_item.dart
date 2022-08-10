import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/cart.dart';
import '../../product_details_screen/product_details_screen.dart';
import '../../../models/product.dart';
import '../../widgets/item_button.dart';

class ProductItem extends StatelessWidget {
  final double _radius = 8.0;
  const ProductItem({super.key});

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
        item.imageUrl,
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    final Product item = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);

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
          gradient: LinearGradient(
            colors: [
              Colors.teal.withOpacity(0.64),
              Colors.teal,
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
            _showImage(item),
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
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Consumer<Product>(
                              builder: (BuildContext context, Product item,
                                      Widget? child) =>
                                  ItemButton(
                                onPressed: () {
                                  item.setFavorite();
                                },
                                icon: item.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Flexible(
                            child: ItemButton(
                              onPressed: () {
                                cart.addItem(item.id, item.price, item.title);
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('x1 ${item.title} added to cart'),
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
                                    duration: const Duration(milliseconds: 768),
                                  ),
                                );
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
