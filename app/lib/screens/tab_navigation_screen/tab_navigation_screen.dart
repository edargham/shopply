import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication.dart';
import '../../providers/products.dart';
import '../../providers/user.dart';

import '../products_screen/products_screen.dart';
import '../products_screen/search_screen.dart';

import '../widgets/main_drawer.dart';
import '../widgets/cart_button.dart';
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

  Widget _showContextMenuButton() {
    return ContextMenuButton(
      child: PopupMenuButton(
        onSelected: (selectedOption) {
          setState(() {
            _filterFavorites = selectedOption == _FilterOptions.showFavorites;
            for (int i = 0; i < _screens.length; i++) {
              if (_screens[i]['name'] == 'search') {
                _screens[i]['screen'] = SearchScreen(
                  searchQuery: _searchQuery,
                  filterFavorites: _filterFavorites,
                );
              } else {
                _screens[i]['screen'] =
                    ProductsScreen(filterFavorites: _filterFavorites);
              }
            }
            // _screens[0]['screen'] =
            //     ProductsScreen(filterFavorites: _filterFavorites);
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
    );
  }

  void _search(BuildContext ctx) {
    FocusManager.instance.primaryFocus?.unfocus();
    String? token = Provider.of<Authentication>(context, listen: false).token;
    Provider.of<Products>(context, listen: false)
        .searchFor(_searchQuery, token: token);
    for (int i = 0; i < _screens.length; i++) {
      if (_screens[i]['name'] == 'search') {
        _screens[i]['screen'] = SearchScreen(
          searchQuery: _searchQuery,
          filterFavorites: _filterFavorites,
        );
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
        'actions': <Widget>[
          const CartButton(),
          _showContextMenuButton(),
        ],
        'screen': ProductsScreen(
          filterFavorites: _filterFavorites,
        ),
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
          const CartButton(),
          _showContextMenuButton(),
        ],
        'screen': SearchScreen(
          searchQuery: _searchQuery,
          filterFavorites: _filterFavorites,
        ),
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
