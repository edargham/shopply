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
  final FocusNode _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlTextBoxController =
      TextEditingController();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_onFocusChanged);
    _priceFocusNode.dispose();
    _textFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlTextBoxController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  Widget _showImage() {
    return _imageUrlTextBoxController.text.isEmpty
        ? const Align(
            alignment: Alignment.center,
            child: Text('Enter a URL'),
          )
        : FittedBox(child: Image.network(_imageUrlTextBoxController.text));
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
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                caption: 'Description',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 256,
                  margin: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  child: _showImage(),
                ),
              ),
              TextBox(
                caption: 'Image URL',
                actionButton: TextInputAction.next,
                inputType: TextInputType.url,
                focusNode: _imageUrlFocusNode,
                controller: _imageUrlTextBoxController,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_textFocusNode);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
