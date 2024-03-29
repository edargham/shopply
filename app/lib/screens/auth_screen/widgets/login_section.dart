import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user.dart';
import '../../../utilities/string_utils.dart';

import '../../../providers/authentication.dart';

import '../../widgets/main_button.dart';
import '../../widgets/text_box.dart';

import '../../widgets/dialogs.dart';

class _LoginViewModel {
  final String username;
  final String password;

  const _LoginViewModel({
    required this.username,
    required this.password,
  });
}

class LoginSection extends StatefulWidget {
  final VoidCallback onEnterEditMode;
  final VoidCallback onExitEditMode;
  const LoginSection({
    Key? key,
    required this.onEnterEditMode,
    required this.onExitEditMode,
  }) : super(key: key);

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
        var res = await Provider.of<Authentication>(context, listen: false)
            .login(_loginViewModel.username, _loginViewModel.password);
        if (res.message != null || res.status != 200) {
          String errors = '';
          if (res.errors != null) {
            errors = unwrapList(res.errors!.map((e) => e.msg).toList());
          } else if (res.message != null) {
            errors = res.message!;
          }

          if (!mounted) return;
          showValidationErrors(context, errors);

          setState(() {
            _isloading = false;
          });
        } else {
          setState(() {
            _isloading = false;
          });

          if (!mounted) return;

          Authentication authHandler =
              Provider.of<Authentication>(context, listen: false);

          authHandler.username = _loginViewModel.username;

          User userHandler = Provider.of<User>(context, listen: false);

          await userHandler.getUser(authHandler.token!, authHandler.username!);

          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed("/");
        }
      } catch (_) {
        showExceptionDialog(context);
        setState(() {
          _isloading = false;
        });
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
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Enter your credentials below to login to Shopply.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              TextBox(
                caption: 'Username',
                onTap: widget.onEnterEditMode,
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
                onTap: widget.onEnterEditMode,
                actionButton: TextInputAction.done,
                focusNode: _passwordFocusNode,
                isPassword: true,
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
