import 'package:flutter/material.dart';

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
        color: Colors.teal,
      ),
      title: Text(
        caption,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
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
                  Colors.teal.withOpacity(0.64),
                  Colors.teal,
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
