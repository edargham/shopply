import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tab_navigation_screen/widgets/main_drawer.dart';
import './screens/tab_navigation_screen/tab_navigation_screen.dart';
import './screens/product_details_screen/product_details_screen.dart';
import './screens/shopping_cart_screen/shopping_cart_screen.dart';

import './providers/products.dart';

import './models/cart.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopply',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.teal),
            bodyMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black),
          ),
          primaryColor: Colors.teal,
          colorScheme: ColorScheme(
            primary: Colors.white,
            onPrimary: Colors.black,
            secondary: Colors.teal,
            onSecondary: Colors.white,
            error: Colors.red.shade800,
            onError: Colors.white,
            background: Colors.teal,
            onBackground: Colors.white,
            surface: Colors.teal,
            onSurface: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.teal),
          ),
          primaryColor: Colors.teal,
          colorScheme: ColorScheme(
            primary: Colors.black12,
            onPrimary: Colors.white,
            secondary: Colors.teal,
            onSecondary: Colors.white,
            error: Colors.red.shade800,
            onError: Colors.white,
            background: Colors.teal,
            onBackground: Colors.white,
            surface: Colors.teal,
            onSurface: Colors.white,
            brightness: Brightness.light,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const TabNavigationScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          ShoppingCartScreen.routeName: (ctx) => const ShoppingCartScreen(),
          '/manage': (ctx) => Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Manage',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                  elevation: 0,
                ),
                drawer: const MainDrawer(),
                body: const Center(
                  child: Text('Manage'),
                ),
              ),
        },
      ),
    );
  }
}
