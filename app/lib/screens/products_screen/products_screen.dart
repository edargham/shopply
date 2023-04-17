import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/product.dart';
import './widgets/product_item.dart';
import '../../providers/products.dart';

class ProductsScreen extends StatefulWidget {
  final bool filterFavorites;
  const ProductsScreen({
    Key? key,
    required this.filterFavorites,
  }) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _init = true;
  bool _isLoading = false;

  Future<void> _refreshItems(BuildContext context) async {
    return await Provider.of<Products>(context, listen: false).getProducts();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Products productsProvider = Provider.of<Products>(context);
    final List<Product> products = widget.filterFavorites
        ? productsProvider.items
            .where((Product item) => item.isFavorite)
            .toList()
        : productsProvider.items;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.background,
        ),
      );
    }

    if (products.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () => _refreshItems(context),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
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
}
