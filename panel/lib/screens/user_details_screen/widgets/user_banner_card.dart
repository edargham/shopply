import 'package:flutter/material.dart';

import '../../../models/view_models/user.dart';

class UserBannerCard extends StatelessWidget {
  final User user;

  const UserBannerCard({super.key, required this.user});

  Widget _showUserCard(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: Theme.of(context).colorScheme.primary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 64.0,
          vertical: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '@${user.username}',
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: 132.0,
            child: _showUserCard(context),
          ),
          Positioned(
            top: 4.0,
            child: Material(
              borderRadius: BorderRadius.circular(72.0),
              elevation: 4,
              child: CircleAvatar(
                radius: 72.0,
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                child: CircleAvatar(
                  radius: 64.0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  backgroundImage: (user.profilePhotoUrl != null)
                      ? NetworkImage(user.profilePhotoUrl!)
                      : null,
                  child: (user.profilePhotoUrl != null)
                      ? null
                      : Text(
                          '${user.firstName[0]}${user.lastName[0]}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 64.0,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
