import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/user.dart' as model;
import '../../providers/user.dart';

import './widgets/user_banner_card.dart';

import '../widgets/item_button.dart';
import '../widgets/main_drawer.dart';
import '../widgets/section_header.dart';

class UserDetailsScreen extends StatelessWidget {
  static const String routeName = '/user-profile';
  const UserDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final model.User? currentUser = Provider.of<User>(context).currentUser;
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
              onPressed: () {},
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
                      icon: Icons.access_time,
                      title: 'Joined',
                      description:
                          '${currentUser.dateJoined.day}/${currentUser.dateJoined.month}/${currentUser.dateJoined.year}',
                    ),
                    SectionHeader(
                      color: Theme.of(context).colorScheme.background,
                      icon: Icons.calendar_month,
                      title: 'Date of Birth',
                      description:
                          '${currentUser.dateOfBirth.day}/${currentUser.dateOfBirth.month}/${currentUser.dateOfBirth.year}',
                    ),
                    SectionHeader(
                      color: Theme.of(context).colorScheme.background,
                      icon:
                          currentUser.sex == 'Male' ? Icons.male : Icons.female,
                      title: 'Sex',
                      description: currentUser.sex,
                    ),
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
