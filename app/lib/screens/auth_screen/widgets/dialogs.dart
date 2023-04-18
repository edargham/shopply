import 'package:flutter/material.dart';

import '../../widgets/item_button.dart';

void showValidationErrors(BuildContext context, String errors) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text(
          'Shopply',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'We encountered an error while processing your request.\n\n$errors',
        ),
        actions: [
          ItemButton(
            icon: Icons.check,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      );
    },
  );
}

void showExceptionDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: const Text(
          'Shopply',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        content:
            const Text('We encountered an error while processing your request.'
                '\nPlease try again later.'),
        actions: [
          ItemButton(
            icon: Icons.check,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      );
    },
  );
}
