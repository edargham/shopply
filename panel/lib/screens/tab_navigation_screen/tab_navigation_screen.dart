import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication.dart';
import '../../providers/products.dart';
import '../../providers/user.dart';

import '../manage_products_screen/manage_products_screen.dart';
import '../search_screen/search_screen.dart';

import '../widgets/main_drawer.dart';
import '../widgets/item_button.dart';
import '../widgets/search_box.dart';

import './widgets/context_menu_button.dart';

enum _FilterOptions {
  showFavorites,
  showAll,
}

class TabNavigationScreen extends StatefulWidget {
  const TabNavigationScreen({super.key});
  @override
  State<TabNavigationScreen> createState() => _TabNavigationScreenState();
}

class _TabNavigationScreenState extends State<TabNavigationScreen> {
  late List<Map<String, Object>> _screens;
  late bool _filterFavorites;
  int _selectedScreenIdx = 0;
  late String _searchQuery;

  void _search(BuildContext ctx) {
    FocusManager.instance.primaryFocus?.unfocus();
    String? token = Provider.of<Authentication>(context, listen: false).token;
    Provider.of<Products>(context, listen: false)
        .searchFor(_searchQuery, token: token);
    for (int i = 0; i < _screens.length; i++) {
      if (_screens[i]['name'] == 'search') {
        _screens[i]['screen'] = SearchScreen(searchQuery: _searchQuery);
        break;
      }
    }
  }

  void _onSearchQueryChanged(val) {
    setState(() {
      _searchQuery = val;
    });
  }

  @override
  void initState() {
    _filterFavorites = false;
    _searchQuery = '';
    _screens = [
      {
        'name': 'home',
        'title': const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        'actions': <Widget>[],
        'screen': const ManageProductsScreen(),
      },
      {
        'name': 'search',
        'title': SearchBox(
          caption: 'Search',
          onChange: _onSearchQueryChanged,
        ),
        'actions': <Widget>[
          ItemButton(
            onPressed: () => _search(context),
            icon: Icons.search,
          ),
        ],
        'screen': SearchScreen(searchQuery: _searchQuery),
      },
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    String? token = Provider.of<Authentication>(context, listen: false).token;
    String? username =
        Provider.of<Authentication>(context, listen: false).username;
    User user = Provider.of<User>(context, listen: false);

    if (token != null && username != null && user.currentUser == null) {
      user.getUser(token, username).then((_) {
        if (user.currentUser == null) {
          Provider.of<Authentication>(context, listen: false).token = null;
          Provider.of<Authentication>(context, listen: false).username = null;
        }
      });
    }

    super.didChangeDependencies();
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIdx = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const int numTabs = 2;
    return DefaultTabController(
      length: numTabs,
      child: Scaffold(
        appBar: AppBar(
          title: _screens[_selectedScreenIdx]['title'] as Widget,
          elevation: 0,
          centerTitle: false,
          actions: _screens[_selectedScreenIdx]['actions'] as List<Widget>,
        ),
        drawer: const MainDrawer(),
        body: _screens[_selectedScreenIdx]['screen'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectScreen,
          currentIndex: _selectedScreenIdx,
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Theme.of(context).colorScheme.surface,
          // type: BottomNavigationBarType.shifting,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
              ),
              activeIcon: Icon(
                Icons.shopping_bag,
              ),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),
              activeIcon: Icon(
                Icons.search,
              ),
              label: 'Search',
            ),
          ],
        ),
      ),
    );
  }
}
