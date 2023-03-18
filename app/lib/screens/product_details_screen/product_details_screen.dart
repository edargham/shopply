import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';

import '../../models/product.dart';
import '../../models/cart.dart';

import '../widgets/cart_button.dart';
import '../widgets/main_button.dart';
import './widgets/section_header.dart';
import './widgets/title_banner.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = '/product_details';
  const ProductDetailsScreen({super.key});

  Widget _showImage(Product item) {
    // try {
    return Image.network(
      item.imageUrl,
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
                  _showImage(item),
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
                          icon: Icons.list,
                          title: 'Description',
                        ),
                        Container(
                          height: 256,
                          padding: const EdgeInsets.all(indentation),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Expanded(
                              child: Text(item.description),
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
                      child: MainButton(
                        onPressed: () {
                          cart.addItem(item.id, item.price, item.title);
                        },
                        title: 'BUY',
                        icon: Icons.add_shopping_cart,
                      ),
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
}
