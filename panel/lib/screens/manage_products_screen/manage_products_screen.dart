import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/product.dart';
import '../../providers/products.dart';

import './widgets/manage_product_item.dart';

class ManageProductsScreen extends StatefulWidget {
  static const String routeName = '/manage';
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
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

  Widget _showBody(BuildContext context) {
    final Products productsProvider = Provider.of<Products>(context);
    final List<Product> products = productsProvider.items;

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
              child: const ManageProductItem(),
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

  @override
  Widget build(BuildContext context) {
    return _showBody(context);
  }
}
