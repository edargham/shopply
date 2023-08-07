import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/product.dart';

import '../../providers/authentication.dart';
import '../../providers/products.dart';

import '../../services/product_service.dart';

import '../widgets/dialogs.dart';
import '../widgets/text_box.dart';
import '../widgets/image_input_box.dart';
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
  final FocusNode _stockFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, Object?> _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'stock': '',
    'file': null,
  };

  bool _init = true;
  bool _isloading = false;

  Product _editedProduct = Product(
      id: '',
      title: '',
      description: '',
      imageUrl: '',
      price: 0.0,
      stock: 0,
      imgFile: null);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_init) {
      final String? productId = (ModalRoute.of(context)?.settings.arguments
          as Map<String, String?>)['productId'];
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findProductById(productId);

        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'stock': _editedProduct.stock.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'file': _editedProduct.imgFile,
        };

        if (_editedProduct.imageUrl != null) {
          File file = await ProductService.getPhotoAsFile(
              _editedProduct.imageUrl!, _editedProduct.title);

          setState(() {
            _initValues['file'] = file;
          });
        }
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _stockFocusNode.dispose();
    _textFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) async {
    String? token = Provider.of<Authentication>(context, listen: false).token;
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();

      if (_editedProduct.id.isEmpty) {
        setState(() {
          _isloading = true;
        });
        Product newProduct = Product(
          id: 'p${DateTime.now()}',
          description: _editedProduct.description,
          title: _editedProduct.title,
          price: _editedProduct.price,
          stock: _editedProduct.stock,
          imgFile: _editedProduct.imgFile,
        );
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(token!, newProduct);
          if (!mounted) return;
          Navigator.of(context).pop();
        } catch (_) {
          showExceptionDialog(context);
          setState(() {
            _isloading = false;
          });
        }
      } else {
        setState(() {
          _isloading = true;
        });
        Product newProduct = Product(
          id: _editedProduct.id,
          description: _editedProduct.description,
          title: _editedProduct.title,
          price: _editedProduct.price,
          stock: _editedProduct.stock,
          imageUrl: _editedProduct.imageUrl,
          imgFile: _editedProduct.imgFile,
        );
        try {
          String? token =
              Provider.of<Authentication>(context, listen: false).token;
          await Provider.of<Products>(context, listen: false)
              .updateProduct(token!, newProduct);
          if (!mounted) return;
          Navigator.of(context).pop();
        } catch (_) {
          showExceptionDialog(context);

          setState(() {
            _isloading = false;
          });
        }
      }
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  Widget _showBody(BuildContext context) {
    if (_isloading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.background,
        ),
      );
    } else {
      return Padding(
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
                initalValue: _initValues['title'] as String,
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
                    stock: _editedProduct.stock,
                    imgFile: _editedProduct.imgFile,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Price',
                initalValue: _initValues['price'] as String,
                actionButton: TextInputAction.next,
                inputType: TextInputType.number,
                focusNode: _priceFocusNode,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_stockFocusNode);
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
                    stock: _editedProduct.stock,
                    imgFile: _editedProduct.imgFile,
                  );
                },
              ),
              TextBox(
                caption: 'Stock',
                initalValue: _initValues['stock'] as String,
                actionButton: TextInputAction.next,
                inputType: TextInputType.number,
                focusNode: _stockFocusNode,
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a stock quantity for your product.';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number for the stock quantity.';
                  } else if (double.parse(value) <= 0) {
                    return 'Please enter a strictly positve stock quantity for your product.';
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
                    price: _editedProduct.price,
                    stock: int.parse(value!),
                    imgFile: _editedProduct.imgFile,
                  );
                },
              ),
              TextBox(
                caption: 'Description',
                initalValue: _initValues['description'] as String,
                actionButton: TextInputAction.newline,
                inputType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                onChange: (_) {},
                onSubmit: (_) {},
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
                    stock: _editedProduct.stock,
                    imgFile: _editedProduct.imgFile,
                  );
                },
              ),
              ImageInputBox(
                initialFile: _initValues['file'] as File?,
                onImageSelected: (File file) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    stock: _editedProduct.stock,
                    imgFile: file,
                  );
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
      );
    }
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
      body: _showBody(context),
    );
  }
}
