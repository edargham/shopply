import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background.withOpacity(0.32),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: const Center(child: Text('Auth Screen')),
      ),
    );
  }
}
