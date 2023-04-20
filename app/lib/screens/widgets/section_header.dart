import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    this.description,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Text((description != null) ? description.toString() : ''),
        ],
      ),
    );
  }
}
