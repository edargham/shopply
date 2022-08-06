import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import './widgets/product_item.dart';
import '../../providers/products.dart';

class ProductsScreen extends StatelessWidget {
  final bool filterFavorites;
  const ProductsScreen({
    Key? key,
    required this.filterFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Products productsProvider = Provider.of<Products>(context);
    final List<Product> products = filterFavorites
        ? productsProvider.items
            .where((Product item) => item.isFavorite)
            .toList()
        : productsProvider.items;

    if (products.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GridView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext ctx, int i) =>
              ChangeNotifierProvider.value(
            value: products[i],
            child: const ProductItem(),
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
      return const Center(
        child: Text(
          'No items currently to show here.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      );
    }
  }
}
