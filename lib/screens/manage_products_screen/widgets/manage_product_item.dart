import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../providers/products.dart';
import '../../product_form_screen/product_form_screen.dart';
import '../../widgets/item_button.dart';

class ManageProductItem extends StatefulWidget {
  const ManageProductItem({super.key});

  @override
  State<ManageProductItem> createState() => _ManageProductItemState();
}

class _ManageProductItemState extends State<ManageProductItem> {
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

  void _showAlert(BuildContext context, Product item) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Shopply'),
          content: const Text('Are you sure you want to remove this item?'),
          actions: <Widget>[
            ItemButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(item);
                } catch (_) {
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
                if (!mounted) return;
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    final Product item = Provider.of<Product>(context);
    const double hScale = 0.32;

    return Container(
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
                        Expanded(
                          child: Consumer<Product>(
                            builder: (BuildContext context, Product item,
                                    Widget? child) =>
                                ItemButton(
                              onPressed: () {
                                _showAlert(context, item);
                              },
                              icon: Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ItemButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ProductFormScreen.routeName,
                                arguments: {
                                  'productId': item.id,
                                },
                              );
                            },
                            color: Colors.amber,
                            icon: Icons.edit,
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
    );
  }
}
