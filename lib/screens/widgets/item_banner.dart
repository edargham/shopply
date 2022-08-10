import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart.dart';
import '../product_details_screen/product_details_screen.dart';

import '../widgets/item_button.dart';

class ItemBanner extends StatefulWidget {
  final CartItem item;
  final String productId;
  final bool enabled;
  const ItemBanner({
    super.key,
    required this.item,
    required this.productId,
    this.enabled = true,
  });

  @override
  State<ItemBanner> createState() => _ItemBannerState();
}

class _ItemBannerState extends State<ItemBanner> {
  Widget _showModalItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.surface,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (_) {
        return SizedBox(
          height: 112,
          child: ListView(
            children: [
              _showModalItem(
                context,
                icon: Icons.remove_shopping_cart_outlined,
                title: 'Remove from cart',
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Shopply'),
                      content: const Text(
                          'Are you sure you want to remove this item?'),
                      actions: <Widget>[
                        ItemButton(
                          onPressed: () {
                            final Cart item =
                                Provider.of<Cart>(context, listen: false);
                            item.deleteItem(widget.productId);
                            Navigator.pop(context);
                          },
                          icon: Icons.check,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        ItemButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icons.close,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ],
                    ),
                  );

                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
              _showModalItem(
                context,
                icon: Icons.exit_to_app,
                title: 'Go to item details',
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailsScreen.routeName,
                    arguments: {
                      'productId': widget.productId,
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showChild(MediaQueryData deviceDisplay, double hScale,
      BuildContext context, double radius) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
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
                      widget.item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Quantity: ${widget.item.quantity}',
                      style: const TextStyle(
                        fontSize: 8.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text('\$${widget.item.price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    const double radius = 8.0;
    const double hScale = 0.08;
    if (widget.enabled) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailsScreen.routeName,
            arguments: {
              'productId': widget.productId,
            },
          );
        },
        onLongPress: () {
          _showBottomMenu(context);
        },
        borderRadius: BorderRadius.circular(radius),
        child: _showChild(deviceDisplay, hScale, context, radius),
      );
    } else {
      return _showChild(deviceDisplay, hScale, context, radius);
    }
  }
}
