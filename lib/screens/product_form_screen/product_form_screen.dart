import 'package:flutter/material.dart';

import '../widgets/text_box.dart';

class ProductFormScreen extends StatefulWidget {
  static const String routeName = '/product_form';

  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _textFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add/Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextBox(
                actionButton: TextInputAction.next,
                focusNode: _textFocusNode,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                caption: 'Title',
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Price',
                actionButton: TextInputAction.next,
                inputType: TextInputType.number,
                focusNode: _priceFocusNode,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextBox(
                actionButton: TextInputAction.newline,
                inputType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_textFocusNode);
                },
                caption: 'Description',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
