import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/products.dart';

import '../widgets/text_box.dart';
import '../widgets/item_button.dart';
import '../widgets/main_button.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _imageUrlTextBoxController =
      TextEditingController();
  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_onFocusChanged);
    super.initState();
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

  void _saveForm(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();

      Product newProduct = Product(
        id: 'p${DateTime.now()}',
        description: _editedProduct.description,
        title: _editedProduct.title,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl,
      );

      Provider.of<Products>(context, listen: false).addProduct(newProduct);
      Navigator.of(context).pop();
    }
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 1.0,
            ),
            child: ItemButton(
              onPressed: () {
                _saveForm(context);
              },
              icon: Icons.save,
            ),
          )
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 8.0),
              TextBox(
                caption: 'Title',
                actionButton: TextInputAction.next,
                focusNode: _textFocusNode,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for your product.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value!,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
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
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price for your product.';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number for the price.';
                  } else if (double.parse(value) <= 0) {
                    return 'Please enter a strictly positve price for your product.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value!),
                  );
                },
              ),
              TextBox(
                caption: 'Description',
                actionButton: TextInputAction.newline,
                inputType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid description.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
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
                actionButton: TextInputAction.done,
                inputType: TextInputType.url,
                focusNode: _imageUrlFocusNode,
                controller: _imageUrlTextBoxController,
                onChange: (_) {},
                onSubmit: (_) {
                  _showImage();
                },
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: value!,
                    price: _editedProduct.price,
                  );
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid image link your product.';
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainButton(
                  onPressed: () => _saveForm(context),
                  title: 'SAVE',
                  icon: Icons.save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
