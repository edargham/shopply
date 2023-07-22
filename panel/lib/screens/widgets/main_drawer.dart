import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/sys_admin.dart' as model;

import '../../providers/authentication.dart';
import '../../providers/sys_admin.dart';

import '../auth_screen/auth_screen.dart';
import '../order_history_screen/order_history_screen.dart';
import '../user_details_screen/user_details_screen.dart';

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

  Widget _renderWelcome(model.SysAdmin? user) => (user != null)
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Welcome @${user.username}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        )
      : Container();

  @override
  Widget build(BuildContext context) {
    final String? token =
        Provider.of<Authentication>(context, listen: false).token;
    final model.SysAdmin? currentUser =
        Provider.of<SysAdmin>(context).currentUser;
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
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.32),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Align(
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
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                _renderWelcome(currentUser),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          (token != null)
              ? _buildListTile(
                  context: context,
                  icon: Icons.person,
                  caption:
                      '${currentUser!.firstName}\'${(currentUser.firstName.lastIndexOf('s') == (currentUser.firstName.length - 1)) ? '' : 's'} Profile',
                  tileTapped: () {
                    Navigator.of(context)
                        .pushNamed(UserDetailsScreen.routeName);
                  },
                )
              : _buildListTile(
                  context: context,
                  icon: Icons.login,
                  caption: 'Login',
                  tileTapped: () {
                    Navigator.of(context).pushNamed(AuthScreen.routeName);
                  },
                ),
          _buildListTile(
            context: context,
            icon: Icons.shopping_cart,
            caption: 'Manage Products',
            tileTapped: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          (token != null)
              ? _buildListTile(
                  context: context,
                  icon: Icons.assignment,
                  caption: 'Orders',
                  tileTapped: () {
                    Navigator.of(context)
                        .pushReplacementNamed(OrderHistoryScreen.routeName);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
