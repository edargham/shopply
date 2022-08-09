import 'package:flutter/material.dart';

import '../../order_history_screen/order_history_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  ListTile _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String caption,
    required VoidCallback tileTapped,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.surface,
      ),
      title: Text(
        caption,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      onTap: tileTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 256,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.background.withOpacity(0.64),
                  Theme.of(context).colorScheme.background,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Shopply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          _buildListTile(
            context: context,
            icon: Icons.shopping_cart,
            caption: 'Shop',
            tileTapped: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.history,
            caption: 'Orders',
            tileTapped: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrderHistoryScreen.routeName);
            },
          ),
          _buildListTile(
            context: context,
            icon: Icons.shop_rounded,
            caption: 'Manage Products',
            tileTapped: () {
              Navigator.of(context).pushReplacementNamed('/manage');
            },
          ),
        ],
      ),
    );
  }
}
