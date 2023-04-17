import 'package:flutter/material.dart';

import '../products_screen/products_screen.dart';
import './widgets/main_drawer.dart';
import './widgets/context_menu_button.dart';
import '../widgets/cart_button.dart';

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

  @override
  void initState() {
    _filterFavorites = false;
    _screens = [
      {
        'title': 'Products',
        'actions': <Widget>[
          const CartButton(),
          ContextMenuButton(
            child: PopupMenuButton(
              onSelected: (selectedOption) {
                setState(() {
                  _filterFavorites =
                      selectedOption == _FilterOptions.showFavorites;
                  _screens[0]['screen'] =
                      ProductsScreen(filterFavorites: _filterFavorites);
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: _FilterOptions.showFavorites,
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: Text('Show Favorites'),
                  ),
                ),
                PopupMenuItem(
                  value: _FilterOptions.showAll,
                  child: ListTile(
                    leading: Icon(
                      Icons.apps,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    title: const Text('Show All'),
                  ),
                ),
              ],
            ),
          ),
        ],
        'screen': ProductsScreen(
          filterFavorites: _filterFavorites,
        ),
      },
      {
        'title': 'Search',
        'actions': <Widget>[],
        'screen': const Scaffold(),
      },
    ];
    super.initState();
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
          title: Text(
            _screens[_selectedScreenIdx]['title'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
