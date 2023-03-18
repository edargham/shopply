import 'package:flutter/material.dart';

class FavoriteLoadingIndicator extends StatelessWidget {
  const FavoriteLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 8.0;
    return Container(
      margin: const EdgeInsets.all(4.0),
      height: 48,
      width: 48,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.64),
            Colors.red,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
