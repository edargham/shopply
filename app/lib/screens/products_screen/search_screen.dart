import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/product.dart';
import '../../providers/authentication.dart';
import './widgets/product_item.dart';
import '../../providers/products.dart';

class SearchScreen extends StatefulWidget {
  final bool filterFavorites;
  final String searchQuery;
  const SearchScreen({
    Key? key,
    required this.filterFavorites,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _init = true;
  bool _isLoading = false;

  Future<void> _refreshItems(BuildContext context) async {
    String? token = Provider.of<Authentication>(context, listen: false).token;
    return await Provider.of<SearchResults>(context, listen: false)
        .searchFor(widget.searchQuery, token: token);
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
      String? token = Provider.of<Authentication>(context).token;
      Provider.of<SearchResults>(context)
          .searchFor(widget.searchQuery, token: token)
          .then((_) {
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
    final SearchResults productsProvider = Provider.of<SearchResults>(context);
    final List<Product> products = widget.filterFavorites
        ? productsProvider.searchResults
            .where((Product item) => item.isFavorite)
            .toList()
        : productsProvider.searchResults;

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
            Icons.search,
            size: 64.0,
            color: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(height: 16.0),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Provide the name of the item you are looking for'
                ' and let the results roll.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
