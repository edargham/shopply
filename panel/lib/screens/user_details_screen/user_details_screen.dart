import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/sys_admin.dart' as model;
import '../../providers/sys_admin.dart';

import '../profile_settings_screen/profile_settings_screen.dart';

import './widgets/user_banner_card.dart';

import '../widgets/item_button.dart';
import '../widgets/main_drawer.dart';
import '../widgets/section_header.dart';

class UserDetailsScreen extends StatelessWidget {
  static const String routeName = '/user-profile';

  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model.SysAdmin? currentUser =
        Provider.of<SysAdmin>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentUser!.firstName}\'s Profile',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: ItemButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileSettingsScreen.routeName);
              },
              icon: Icons.edit_outlined,
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            UserBannerCard(user: currentUser),
            Material(
              borderRadius: BorderRadius.circular(8.0),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(context).colorScheme.primary,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SectionHeader(
                      color: Theme.of(context).colorScheme.background,
                      icon: Icons.mail_outline,
                      title: 'Email',
                      description: currentUser.email,
                    ),
                    SectionHeader(
                      color: Theme.of(context).colorScheme.background,
                      icon: Icons.phone,
                      title: 'Phone',
                      description: currentUser.phoneNumber,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
