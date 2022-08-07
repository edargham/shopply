import 'package:flutter/material.dart';

import '../../../models/cart.dart';
import '../../product_details_screen/product_details_screen.dart';

class ItemBanner extends StatelessWidget {
  final CartItem item;
  final String productId;
  const ItemBanner({
    super.key,
    required this.item,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    const double radius = 8.0;
    const double hScale = 0.08;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          ProductDetailsScreen.routeName,
          arguments: {
            'productId': productId,
          },
        );
      },
      onLongPress: () {
        // TODO - Show bottom modal to delete item.
      },
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          padding: const EdgeInsets.fromLTRB(
            0,
            0,
            8.0,
            0,
          ),
          margin: const EdgeInsets.all(4.0),
          height: deviceDisplay.size.height * hScale,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(0.32),
                Colors.grey,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag),
                    const SizedBox(width: 4.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 8.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text('\$${item.price.toStringAsFixed(2)}'),
              ],
            ),
          )),
    );
  }
}
