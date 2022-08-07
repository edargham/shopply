import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color color;
  const MainButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.icon,
    this.color = Colors.teal,
  });

  Widget _showTitle(BuildContext context) {
    return icon != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          )
        : Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    const double radius = 8.0;
    const double hScale = 0.08;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          0,
          0,
          8.0,
          0,
        ),
        margin: const EdgeInsets.all(4.0),
        height: deviceDisplay.size.height * hScale,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
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
        child: Align(
          alignment: Alignment.center,
          child: _showTitle(context),
        ),
      ),
    );
  }
}
