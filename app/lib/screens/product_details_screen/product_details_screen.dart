import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication.dart';
import '../../providers/products.dart';

import '../../models/view_models/product.dart';
import '../../providers/cart.dart';

import '../auth_screen/auth_screen.dart';

import './widgets/title_banner.dart';

import '../widgets/cart_button.dart';
import '../widgets/main_button.dart';
import '../widgets/section_header.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product_details';
  const ProductDetailsScreen({super.key});

  Widget _showImage(Product item) {
    // try {
    return Image.network(
      item.imageUrl!,
    );
    // } catch (_) {
    // return const Center(
    //   child: Padding(
    //     padding: EdgeInsets.all(128.0),
    //     child: Text('Image not available.'),
    //   ),
    // );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final String itemId = ((ModalRoute.of(context)?.settings.arguments
        as Map<String, Object>)['productId']) as String;
    final Product item = Provider.of<Products>(
      context,
      listen: false,
    ).findProductById(itemId);

    final Cart cart = Provider.of<Cart>(context);

    final String? token = Provider.of<Authentication>(context).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: CartButton(),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          const double indentation = 16.0;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: <Widget>[
                  (item.imageUrl != null) ? _showImage(item) : Container(),
                  TitleBanner(
                    color: Theme.of(context).primaryColor,
                    title: item.title,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(indentation),
                    child: Column(
                      children: <Widget>[
                        SectionHeader(
                          color: Theme.of(context).colorScheme.background,
                          icon: Icons.money_sharp,
                          title: 'Price',
                          description: '\$${item.price.toString()}',
                        ),
                        const SizedBox(height: 8.0),
                        SectionHeader(
                          color: Theme.of(context).colorScheme.background,
                          icon: Icons.inventory_2_outlined,
                          title: 'Status',
                          description:
                              (item.stock > 0) ? 'In stock' : 'Out of stock',
                        ),
                        const SizedBox(height: 8.0),
                        SectionHeader(
                          color: Theme.of(context).colorScheme.background,
                          icon: Icons.list,
                          title: 'Description',
                        ),
                        Container(
                          height: 256,
                          padding: const EdgeInsets.all(indentation),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Expanded(
                              child: Text((item.description != null)
                                  ? item.description!
                                  : 'This item as no description.'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _showProductPrompt(context, token, cart, item),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _showProductPrompt(
      BuildContext context, String? token, Cart cart, Product item) {
    return (token != null)
        ? MainButton(
            onPressed: () {
              cart.addItem(item.id, item.price, item.title);
            },
            title: 'BUY',
            icon: Icons.add_shopping_cart,
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
}
