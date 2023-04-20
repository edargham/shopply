import 'package:flutter/material.dart';

import './widgets/login_section.dart';
import './widgets/register_section.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  bool _isEditMode = false;

  final GlobalKey<_AuthScreenState> _screenKey = GlobalKey<_AuthScreenState>();

  void _onEnterEditMode() {
    if (!_isEditMode) {
      setState(() {
        _isEditMode = true;
      });
    }
  }

  void _onExitEditMode() {
    if (_isEditMode) {
      setState(() {
        _isEditMode = false;
      });
    }
  }

  Widget _showForm(BuildContext context) {
    return Container(
      key: _screenKey,
      padding: const EdgeInsets.all(48.0),
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
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Shopply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                ),
              ),
            ),
            const Center(
              child: Text('Welcome to the greatest shop in the world.'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: ControllerBody(
                    onEnterEditMode: _onEnterEditMode,
                    onExitEditMode: _onExitEditMode,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showBody(BuildContext context) {
    if (_isEditMode) {
      return SingleChildScrollView(
        child: _showForm(context),
      );
    } else {
      return _showForm(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _onExitEditMode();
        },
        onVerticalDragStart: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
          _onExitEditMode();
        },
        child: _showBody(context),
      ),
    );
  }
}

class ControllerBody extends StatelessWidget {
  final VoidCallback onEnterEditMode;
  final VoidCallback onExitEditMode;
  const ControllerBody({
    Key? key,
    required this.onEnterEditMode,
    required this.onExitEditMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar(
            tabs: const <Tab>[
              Tab(
                text: 'Login',
                icon: Icon(Icons.login),
              ),
              Tab(
                text: 'Register',
                icon: Icon(Icons.person_add),
              ),
            ],
            labelColor: Theme.of(context).colorScheme.background,
            indicatorColor: Theme.of(context).colorScheme.background,
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 320,
            child: TabBarView(
              children: <Widget>[
                LoginSection(
                  onEnterEditMode: onEnterEditMode,
                  onExitEditMode: onExitEditMode,
                ),
                RegisterSection(
                  onEnterEditMode: onEnterEditMode,
                  onExitEditMode: onExitEditMode,
                  onRegister: () {
                    DefaultTabController.of(context).animateTo(0);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
