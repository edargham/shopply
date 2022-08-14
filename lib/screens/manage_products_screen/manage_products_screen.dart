import 'package:flutter/material.dart';

import '../product_form_screen/product_form_screen.dart';
import '../tab_navigation_screen/widgets/main_drawer.dart';
import '../widgets/item_button.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: ItemButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ProductFormScreen.routeName);
              },
              icon: Icons.add,
            ),
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
