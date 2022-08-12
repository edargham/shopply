import 'package:flutter/material.dart';

import '../product_form_screen/product_form_screen.dart';
import '../tab_navigation_screen/widgets/main_drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const String routeName = '/manage';
  const ManageProductsScreen({super.key});

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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProductFormScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      drawer: const MainDrawer(),
      body: const Center(
        child: Text('Manage'),
      ),
    );
  }
}
