import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background.withOpacity(0.32),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 64.0),
                child: Text(
                  'Shopply',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 64.0,
                  ),
                ),
              ),
              const Center(
                child: Text('Welcome to the greatest shop in the world.'),
              ),
              const SizedBox(height: 16.0),
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      const TabBar(
                        tabs: [
                          Tab(
                            text: 'Login',
                            icon: Icon(Icons.login),
                          ),
                          Tab(
                            text: 'Register',
                            icon: Icon(Icons.person_add),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Container(
                              child: const Center(
                                child: Text('Login'),
                              ),
                            ),
                            Container(
                              child: const Center(
                                child: Text('Register'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
