import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/user.dart' as models;

import '../../providers/authentication.dart';
import '../../providers/user.dart';

import '../../utilities/string_utils.dart';
import '../widgets/dialogs.dart';
import '../widgets/main_button.dart';
import '../widgets/text_box.dart';

class _ChangePasswordViewModel {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const _ChangePasswordViewModel({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  _ChangePasswordViewModel _changePasswordViewModel =
      const _ChangePasswordViewModel(
    oldPassword: '',
    newPassword: '',
    confirmPassword: '',
  );

  bool _isEditMode = false;
  bool _isLoading = false;

  void _onEnterEditMode() {
    if (!_isEditMode) {
      setState(() {
        _isEditMode = true;
      });
    }
  }

  void _onExitEditMode() {
    if (_isEditMode) {
      setState(() {
        _isEditMode = false;
      });
    }
  }

  void _saveForm(BuildContext context) async {
    String? token = Provider.of<Authentication>(
      context,
      listen: false,
    ).token;
    String? username = Provider.of<Authentication>(
      context,
      listen: false,
    ).username;

    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        var res =
            await Provider.of<User>(context, listen: false).updatePassword(
          token!,
          username!,
          _changePasswordViewModel.oldPassword,
          _changePasswordViewModel.newPassword,
        );

        if (res.status == 200) {
          setState(() {
            _isLoading = false;
          });

          if (res.message != null) {
            if (!mounted) return;
            showServerMessage(context, res.message!);
          } else {
            if (!mounted) return;
            Navigator.of(context).pop();
          }
        } else {
          String errors = '';
          if (res.errors != null) {
            errors = unwrapList(res.errors!.map((e) => e.msg).toList());
          } else if (res.message != null) {
            errors = res.message!;
          }

          if (!mounted) return;
          showValidationErrors(context, errors);

          setState(() {
            _isLoading = false;
          });
        }
      } catch (ex) {
        showExceptionDialog(context);

        setState(() {
          _isLoading = false;
        });
      }
    }

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 16.0,
            ),
            TextBox(
              caption: 'Old Password',
              actionButton: TextInputAction.next,
              onTap: _onEnterEditMode,
              focusNode: _oldPasswordFocusNode,
              initalValue: _changePasswordViewModel.oldPassword,
              onChange: (String value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: value,
                  newPassword: _changePasswordViewModel.newPassword,
                  confirmPassword: _changePasswordViewModel.confirmPassword,
                );
              },
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(_newPasswordFocusNode);
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You have to provide your old password.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: value!,
                  newPassword: _changePasswordViewModel.newPassword,
                  confirmPassword: _changePasswordViewModel.confirmPassword,
                );
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextBox(
              caption: 'New Password',
              actionButton: TextInputAction.next,
              onTap: _onEnterEditMode,
              focusNode: _newPasswordFocusNode,
              initalValue: _changePasswordViewModel.newPassword,
              onChange: (String value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: _changePasswordViewModel.oldPassword,
                  newPassword: value,
                  confirmPassword: _changePasswordViewModel.confirmPassword,
                );
              },
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(_newPasswordFocusNode);
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter a new password.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: _changePasswordViewModel.oldPassword,
                  newPassword: value!,
                  confirmPassword: _changePasswordViewModel.confirmPassword,
                );
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextBox(
              caption: 'Confirm Password',
              actionButton: TextInputAction.done,
              onTap: _onEnterEditMode,
              focusNode: _confirmPasswordFocusNode,
              initalValue: _changePasswordViewModel.confirmPassword,
              onChange: (String value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: _changePasswordViewModel.oldPassword,
                  newPassword: _changePasswordViewModel.newPassword,
                  confirmPassword: value,
                );
              },
              onSubmit: (_) {},
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please confirm your password.';
                } else if (value != _changePasswordViewModel.newPassword) {
                  return 'Passwords do not match.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changePasswordViewModel = _ChangePasswordViewModel(
                  oldPassword: _changePasswordViewModel.oldPassword,
                  newPassword: _changePasswordViewModel.newPassword,
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
