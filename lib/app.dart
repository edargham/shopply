import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tab_navigation_screen/tab_navigation_screen.dart';
import './screens/product_details_screen/product_details_screen.dart';
import './screens/shopping_cart_screen/shopping_cart_screen.dart';
import './screens/order_history_screen/order_history_screen.dart';
import './screens/manage_products_screen/manage_products_screen.dart';
import './screens/product_form_screen/product_form_screen.dart';
import './screens/auth_screen/auth_screen.dart';

import './providers/products.dart';

import './models/cart.dart';
import './models/order.dart';

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
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Order(),
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
            primary: const Color.fromARGB(255, 48, 48, 48),
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
        initialRoute: AuthScreen.routeName,
        routes: {
          // '/': (BuildContext ctx) => TabNavigationScreen(
          //       backgroundColor: Theme.of(ctx).colorScheme.background,
          //       onPrimaryColor: Theme.of(ctx).colorScheme.onPrimary,
          //     ),
          AuthScreen.routeName: (BuildContext ctx) => const AuthScreen(),
          // ProductDetailsScreen.routeName: (BuildContext ctx) =>
          //     const ProductDetailsScreen(),
          // ShoppingCartScreen.routeName: (BuildContext ctx) =>
          //     const ShoppingCartScreen(),
          // OrderHistoryScreen.routeName: (BuildContext ctx) =>
          //     const OrderHistoryScreen(),
          // ManageProductsScreen.routeName: (BuildContext ctx) =>
          //     const ManageProductsScreen(),
          // ProductFormScreen.routeName: (BuildContext ctx) =>
          //     const ProductFormScreen(),
        },
      ),
    );
  }
}
