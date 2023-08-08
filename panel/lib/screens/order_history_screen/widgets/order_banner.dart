import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../widgets/item_banner.dart';
import '../../widgets/item_button.dart';

import '../../../models/view_models/order.dart';
import '../../../providers/order.dart';

class OrderBanner extends StatefulWidget {
  final OrderItem item;
  const OrderBanner({
    super.key,
    required this.item,
  });

  @override
  State<OrderBanner> createState() => _OrderBannerState();
}

class _OrderBannerState extends State<OrderBanner> {
  bool expanded = false;

  void showAlert(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Shopply'),
        content: const Text('Are you sure you want to remove this item?'),
        actions: <Widget>[
          ItemButton(
            onPressed: () {
              final Order order = Provider.of<Order>(context, listen: false);
              order.deleteOder(widget.item.id!);
              Navigator.pop(context);
            },
            icon: Icons.check,
            color: Theme.of(context).colorScheme.background,
          ),
          ItemButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.close,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _showModalItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.amber,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.hardEdge,
      builder: (_) {
        return SizedBox(
          height: 112,
          child: ListView(
            children: [
              _showModalItem(
                context,
                icon: Icons.delete,
                title: 'Delete Order Data',
                onPressed: () {
                  showAlert(context);
                },
              ),
              !expanded
                  ? _showModalItem(
                      context,
                      icon: Icons.more_horiz,
                      title: 'Show Details',
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                        Navigator.pop(context);
                      },
                    )
                  : _showModalItem(
                      context,
                      icon: Icons.hide_source,
                      title: 'Hide Details',
                      onPressed: () {
                        setState(() {
                          expanded = !expanded;
                        });
                        Navigator.pop(context);
                      },
                    ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceDisplay = MediaQuery.of(context);
    const double radius = 8.0;
    const double hScale = 0.1;
    const double expandedAddedHeight = 256.0;
    const double iconSize = 16.0;
    return InkWell(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      onLongPress: () {
        _showBottomMenu(context);
      },
      borderRadius: BorderRadius.circular(radius),
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
          margin: const EdgeInsets.all(4.0),
          height: !expanded
              ? deviceDisplay.size.height * hScale
              : deviceDisplay.size.height * hScale + expandedAddedHeight,
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
                Colors.amber.withOpacity(0.32),
                Colors.amber,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (widget.item.status != OrderStatus.Completed)
                            ? const Icon(Icons.assignment)
                            : const Icon(Icons.receipt_long),
                        const SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'User: ${widget.item.username!}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Order Id: ${widget.item.id}',
                              style: const TextStyle(
                                fontSize: 8.0,
                              ),
                            ),
                            Text(
                              'Total: \$${widget.item.amount}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              'Order Status: ${widget.item.status.toString().split('.').last}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 8.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(DateFormat('dd/MM/yyyy hh:mm')
                            .format(widget.item.dateOrdered!)),
                        !expanded
                            ? const Icon(
                                Icons.expand_more,
                                size: iconSize,
                              )
                            : const Icon(
                                Icons.expand_less,
                                size: iconSize,
                              ),
                      ],
                    ),
                  ],
                ),
                expanded
                    ? SizedBox(
                        height: expandedAddedHeight,
                        child: ListView.builder(
                          itemCount: widget.item.products.length,
                          itemBuilder: (context, index) => ItemBanner(
                            item: widget.item.products[index],
                            productId: widget.item.products[index].id,
                            enabled: false,
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0.0,
                      ),
              ],
            ),
          )),
    );
  }
}
