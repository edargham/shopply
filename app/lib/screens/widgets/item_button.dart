import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;

  const ItemButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    const double radius = 8.0;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
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
              color.withOpacity(0.64),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
