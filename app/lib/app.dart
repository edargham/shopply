import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/tab_navigation_screen/tab_navigation_screen.dart';
import './screens/product_details_screen/product_details_screen.dart';
import './screens/shopping_cart_screen/shopping_cart_screen.dart';
import './screens/order_history_screen/order_history_screen.dart';
import './screens/manage_products_screen/manage_products_screen.dart';
import './screens/product_form_screen/product_form_screen.dart';
import './screens/auth_screen/auth_screen.dart';
import './screens/user_details_screen/user_details_screen.dart';
import './screens/profile_settings_screen/profile_settings_screen.dart';
import './screens/change_information_screen/change_information_screen.dart';
import './screens/change_email_screen/change_email_screen.dart';
import './screens/change_password_screen/change_password_screen.dart';

import './providers/products.dart';
import './providers/authentication.dart';
import './providers/user.dart';
import './providers/cart.dart';
import './providers/order.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchResults(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => User(),
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
        routes: {
          '/': (ctx) => const TabNavigationScreen(),
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          ShoppingCartScreen.routeName: (ctx) => const ShoppingCartScreen(),
          OrderHistoryScreen.routeName: (ctx) => const OrderHistoryScreen(),
          ManageProductsScreen.routeName: (ctx) => const ManageProductsScreen(),
          ProductFormScreen.routeName: (ctx) => const ProductFormScreen(),
          UserDetailsScreen.routeName: (ctx) => const UserDetailsScreen(),
          ProfileSettingsScreen.routeName: (ctx) =>
              const ProfileSettingsScreen(),
          ChangeInformationScreen.routeName: (ctx) =>
              const ChangeInformationScreen(),
          ChangeEmailScreen.routeName: (ctx) => const ChangeEmailScreen(),
          ChangePasswordScreen.routeName: (ctx) => const ChangePasswordScreen(),
        },
      ),
    );
  }
}
