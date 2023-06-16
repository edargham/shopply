import 'package:flutter/material.dart';

import '../change_email_screen/change_email_screen.dart';
import '../change_information_screen/change_information_screen.dart';
import '../change_password_screen/change_password_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  static const String routeName = '/profile-settings';

  const ProfileSettingsScreen({super.key});

  Widget _buildListItemTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildListItemTile(
            context,
            onPressed: () {
              Navigator.pushNamed(context, ChangeInformationScreen.routeName);
            },
            icon: Icons.person,
            title: 'Change Information',
          ),
          _buildListItemTile(
            context,
            onPressed: () {
              Navigator.pushNamed(context, ChangeEmailScreen.routeName);
            },
            icon: Icons.email,
            title: 'Change Email',
          ),
          _buildListItemTile(
            context,
            onPressed: () {
              Navigator.pushNamed(context, ChangePasswordScreen.routeName);
            },
            icon: Icons.password,
            title: 'Change Password',
          ),
        ],
      ),
    );
  }
}
