import 'package:flutter/material.dart';

import '../../widgets/text_box.dart';

class _LoginViewModel {
  final String username;
  final String password;

  const _LoginViewModel({
    required this.username,
    required this.password,
  });
}

class LoginSection extends StatefulWidget {
  const LoginSection({Key? key}) : super(key: key);

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isloading = false;

  Map<String, String> _initValues = {
    'username': '',
    'passoword': '',
  };

  _LoginViewModel _loginViewModel = _LoginViewModel(
    username: '',
    password: '',
  );

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
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
                caption: 'Username',
                actionButton: TextInputAction.next,
                focusNode: _usernameFocusNode,
                initalValue: _initValues['username'],
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'You have to login with your username.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _loginViewModel = _LoginViewModel(
                    username: value!,
                    password: _loginViewModel.password,
                  );
                },
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
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value!),
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
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
                onSaved: (String? value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value!,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    isFavorite: _editedProduct.isFavorite,
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
                    isFavorite: _editedProduct.isFavorite,
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
