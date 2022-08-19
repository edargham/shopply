import 'package:flutter/material.dart';

import '../../widgets/item_button.dart';
import '../../widgets/main_button.dart';
import '../../widgets/text_box.dart';

class _RegisterViewModel {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const _RegisterViewModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });
}

class RegisterSection extends StatefulWidget {
  const RegisterSection({Key? key}) : super(key: key);

  @override
  State<RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isloading = false;

  _RegisterViewModel _registerViewModel = const _RegisterViewModel(
    username: '',
    firstName: '',
    lastName: '',
    email: '',
    phoneNumber: '',
    password: '',
    confirmPassword: '',
  );

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

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
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Flexible(
                  child: Text(
                    'Enter the  required information below to register if you want to access the features provided by Shopply.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
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
                  // TODO - check if unique
                  if (value!.isEmpty) {
                    return 'You have to provide a username.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: value!,
                    firstName: _registerViewModel.firstName,
                    lastName: _registerViewModel.lastName,
                    email: _registerViewModel.email,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: _registerViewModel.password,
                    confirmPassword: _registerViewModel.confirmPassword,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'First Name',
                actionButton: TextInputAction.next,
                focusNode: _firstNameFocusNode,
                initalValue: '',
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'You have to provide your first name.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: value!,
                    lastName: _registerViewModel.lastName,
                    email: _registerViewModel.email,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: _registerViewModel.password,
                    confirmPassword: _registerViewModel.confirmPassword,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Last Name',
                actionButton: TextInputAction.next,
                focusNode: _lastNameFocusNode,
                initalValue: '',
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'You have to provide your last name.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: _registerViewModel.firstName,
                    lastName: value!,
                    email: _registerViewModel.email,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: _registerViewModel.password,
                    confirmPassword: _registerViewModel.confirmPassword,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Phone Number',
                actionButton: TextInputAction.next,
                inputType: TextInputType.phone,
                focusNode: _phoneNumberFocusNode,
                initalValue: '',
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (String? value) {
                  // TODO - check if unique
                  if (value!.isEmpty) {
                    return 'You have to provide your phone number.';
                  } else if (int.tryParse(value) != null) {
                    return 'Your number must not contain alphabetic characters.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: _registerViewModel.firstName,
                    lastName: _registerViewModel.lastName,
                    email: _registerViewModel.email,
                    phoneNumber: value!,
                    password: _registerViewModel.password,
                    confirmPassword: _registerViewModel.confirmPassword,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Email',
                actionButton: TextInputAction.next,
                inputType: TextInputType.emailAddress,
                focusNode: _emailFocusNode,
                initalValue: '',
                onChange: (_) {},
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                validator: (String? value) {
                  // TODO - check if unique
                  if (value!.isEmpty) {
                    return 'You have to provide your email address.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: _registerViewModel.firstName,
                    lastName: _registerViewModel.lastName,
                    email: value!,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: _registerViewModel.password,
                    confirmPassword: _registerViewModel.confirmPassword,
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
                    return 'You must provide a password.';
                  } else if (value != _registerViewModel.confirmPassword) {
                    return 'Passwords do not match.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: _registerViewModel.firstName,
                    lastName: _registerViewModel.lastName,
                    email: _registerViewModel.email,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: value!,
                    confirmPassword: _registerViewModel.confirmPassword,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextBox(
                caption: 'Confirm Password',
                initalValue: '',
                actionButton: TextInputAction.done,
                focusNode: _confirmPasswordFocusNode,
                onChange: (_) {},
                onSubmit: (_) {},
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Confirm your password just in case.';
                  } else if (value != _registerViewModel.password) {
                    return 'Passwords do not match.';
                  } else {
                    return null;
                  }
                },
                onSaved: (String? value) {
                  _registerViewModel = _RegisterViewModel(
                    username: _registerViewModel.username,
                    firstName: _registerViewModel.firstName,
                    lastName: _registerViewModel.lastName,
                    email: _registerViewModel.email,
                    phoneNumber: _registerViewModel.phoneNumber,
                    password: _registerViewModel.password,
                    confirmPassword: value!,
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainButton(
                  onPressed: () => _saveForm(context),
                  title: 'REGISTER',
                  icon: Icons.person_add,
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
