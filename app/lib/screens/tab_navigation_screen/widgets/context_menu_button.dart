import 'package:flutter/material.dart';

class ContextMenuButton extends StatelessWidget {
  final PopupMenuButton child;
  const ContextMenuButton({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.background.withOpacity(0.64),
            Theme.of(context).colorScheme.background,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}
