import 'package:flutter/material.dart';

class TotalBanner extends StatelessWidget {
  final double totalPrice;
  const TotalBanner({
    super.key,
    this.totalPrice = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    const double radius = 8.0;
    const double hScale = 0.08;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
        margin: const EdgeInsets.all(4.0),
        height: deviceDisplay.size.height * hScale,
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
              Colors.teal.withOpacity(0.64),
              Colors.teal,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.32),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'TOTAL:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text('\$${totalPrice.toStringAsFixed(2)}'),
            ],
          ),
        ));
  }
}
