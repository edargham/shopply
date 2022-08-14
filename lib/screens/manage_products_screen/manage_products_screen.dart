import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/products.dart';

import '../product_form_screen/product_form_screen.dart';
import '../tab_navigation_screen/widgets/main_drawer.dart';

import './widgets/manage_product_item.dart';
import '../widgets/item_button.dart';

class ManageProductsScreen extends StatelessWidget {
  static const String routeName = '/manage';
  const ManageProductsScreen({super.key});

  Widget _showBody(BuildContext context) {
    final Products productsProvider = Provider.of<Products>(context);
    final List<Product> products = productsProvider.items;

    if (products.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext ctx, int i) =>
              ChangeNotifierProvider.value(
            value: products[i],
            child: const ManageProductItem(),
          ),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 512,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.close,
            size: 64.0,
            color: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(height: 16.0),
          const Center(
            child: Text(
              'No items currently to show here.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: ItemButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductFormScreen.routeName,
                  arguments: {
                    'productId': null,
                  },
                );
              },
              icon: Icons.add,
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      drawer: const MainDrawer(),
      body: _showBody(context),
    );
  }
}
