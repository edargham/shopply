import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/product.dart';
import '../../providers/products.dart';

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
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _imageUrlFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _imageUrlTextBoxController =
      TextEditingController();

  Map<String, String> _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool _init = true;
  bool _isloading = false;

  // Product _editedProduct = Product(
  //   id: '',
  //   title: '',
  //   description: '',
  //   imageUrl: '',
  //   price: 0.0,
  // );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_onFocusChanged);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final String? productId = (ModalRoute.of(context)?.settings.arguments
          as Map<String, String?>)['productId'];
      if (productId != null) {
        // _editedProduct = Provider.of<Products>(context, listen: false)
        //     .findProductById(productId);

        // _initValues = {
        //   'title': _editedProduct.title,
        //   'description': _editedProduct.description,
        //   'price': _editedProduct.price.toString(),
        //   'imageUrl': '',
        // };

        // _imageUrlTextBoxController.text = _editedProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
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

  // void _saveForm(BuildContext context) async {
  //   bool isValid = _formKey.currentState!.validate();
  //   if (isValid) {
  //     _formKey.currentState?.save();

  //     if (_editedProduct.id.isEmpty) {
  //       setState(() {
  //         _isloading = true;
  //       });
  //       Product newProduct = Product(
  //         id: 'p${DateTime.now()}',
  //         description: _editedProduct.description,
  //         title: _editedProduct.title,
  //         price: _editedProduct.price,
  //         imageUrl: _editedProduct.imageUrl,
  //       );
  //       try {
  //         await Provider.of<Products>(context, listen: false)
  //             .addProduct(newProduct);
  //         if (!mounted) return;
  //         Navigator.of(context).pop();
  //       } catch (_) {
  //         await showDialog(
  //           context: context,
  //           builder: (BuildContext ctx) {
  //             return AlertDialog(
  //               title: const Text(
  //                 'Shopply',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               content: const Text(
  //                   'We encountered an error while processing your request.'
  //                   '\nPlease try again later.'),
  //               actions: [
  //                 ItemButton(
  //                   icon: Icons.check,
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         if (!mounted) return;
  //         Navigator.of(context).pop();
  //       }
  //     } else {
  //       setState(() {
  //         _isloading = true;
  //       });
  //       // Product newProduct = Product(
  //       //   id: _editedProduct.id,
  //       //   description: _editedProduct.description,
  //       //   title: _editedProduct.title,
  //       //   price: _editedProduct.price,
  //       //   imageUrl: _editedProduct.imageUrl,
  //       // );
  //       try {
  //         await Provider.of<Products>(context, listen: false)
  //             .updateProduct(newProduct);
  //         if (!mounted) return;
  //         Navigator.of(context).pop();
  //       } catch (_) {
  //         await showDialog(
  //           context: context,
  //           builder: (BuildContext ctx) {
  //             return AlertDialog(
  //               title: const Text(
  //                 'Shopply',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               content: const Text(
  //                   'We encountered an error while processing your request.'
  //                   '\nPlease try again later.'),
  //               actions: [
  //                 ItemButton(
  //                   icon: Icons.check,
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //         if (!mounted) return;
  //         Navigator.of(context).pop();
  //       }
  //     }
  //   }
  //   FocusManager.instance.primaryFocus?.unfocus();
  // }

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
                initalValue: _initValues['title'],
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
                // onSaved: (String? value) {
                //   _editedProduct = Product(
                //     id: _editedProduct.id,
                //     title: value!,
                //     description: _editedProduct.description,
                //     imageUrl: _editedProduct.imageUrl,
                //     price: _editedProduct.price,
                //     isFavorite: _editedProduct.isFavorite,
                //   );
                // },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Price',
                initalValue: _initValues['price'],
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
                // onSaved: (String? value) {
                //   _editedProduct = Product(
                //     id: _editedProduct.id,
                //     title: _editedProduct.title,
                //     description: _editedProduct.description,
                //     imageUrl: _editedProduct.imageUrl,
                //     price: double.parse(value!),
                //     isFavorite: _editedProduct.isFavorite,
                //   );
                // },
              ),
              TextBox(
                caption: 'Description',
                initalValue: _initValues['description'],
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
                // onSaved: (String? value) {
                //   _editedProduct = Product(
                //     id: _editedProduct.id,
                //     title: _editedProduct.title,
                //     description: value!,
                //     imageUrl: _editedProduct.imageUrl,
                //     price: _editedProduct.price,
                //     isFavorite: _editedProduct.isFavorite,
                //   );
                // },
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
                // onSaved: (String? value) {
                //   _editedProduct = Product(
                //     id: _editedProduct.id,
                //     title: _editedProduct.title,
                //     description: _editedProduct.description,
                //     imageUrl: value!,
                //     price: _editedProduct.price,
                //     isFavorite: _editedProduct.isFavorite,
                //   );
                // },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter a valid image link your product.';
                  } else {
                    return null;
                  }
                },
              ),
              const ImageInputBox(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainButton(
                  onPressed: () {}, // => _saveForm(context),
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
                // _saveForm(context);
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
