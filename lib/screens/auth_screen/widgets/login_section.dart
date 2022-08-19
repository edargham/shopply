import 'package:flutter/material.dart';

import '../../widgets/item_button.dart';
import '../../widgets/main_button.dart';
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

  _LoginViewModel _loginViewModel = const _LoginViewModel(
    username: '',
    password: '',
  );

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _saveForm(BuildContext context) async {
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState?.save();

      setState(() {
        _isloading = true;
      });

      try {
        // await Provider.of<Products>(context, listen: false)
        //     .updateProduct(newProduct);
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (_) {
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
              content: const Text(
                  'We encountered an error while processing your request.'
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
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    }

    FocusManager.instance.primaryFocus?.unfocus();
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
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Flexible(
                  child: Text(
                    'Enter your credentials below to login to Shopply.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TextBox(
                caption: 'Username',
                actionButton: TextInputAction.next,
                focusNode: _usernameFocusNode,
                initalValue: '',
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
                caption: 'Password',
                initalValue: '',
                actionButton: TextInputAction.done,
                focusNode: _passwordFocusNode,
                onChange: (_) {},
                onSubmit: (_) {},
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'You must enter a password to login.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _loginViewModel = _LoginViewModel(
                    username: _loginViewModel.username,
                    password: value!,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainButton(
                  onPressed: () => _saveForm(context),
                  title: 'LOGIN',
                  icon: Icons.login,
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
    return Container(
      child: _showBody(context),
    );
  }
}
