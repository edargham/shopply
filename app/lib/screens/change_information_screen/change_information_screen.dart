import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/user.dart' as models;

import '../../providers/authentication.dart';
import '../../providers/user.dart';

import '../../utilities/string_utils.dart';
import '../widgets/dialogs.dart';
import '../widgets/item_button.dart';
import '../widgets/main_button.dart';
import '../widgets/text_box.dart';

class _ChangeInformationViewModel {
  final String firstName;
  final String? middleName;
  final String lastName;

  const _ChangeInformationViewModel({
    required this.firstName,
    this.middleName,
    required this.lastName,
  });
}

class ChangeInformationScreen extends StatefulWidget {
  static const String routeName = '/change-information-screen';

  const ChangeInformationScreen({super.key});

  @override
  State<ChangeInformationScreen> createState() =>
      _ChangeInformationScreenState();
}

class _ChangeInformationScreenState extends State<ChangeInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _middleNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  late _ChangeInformationViewModel _changeInformationViewModel =
      const _ChangeInformationViewModel(firstName: '', lastName: '');

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
        var res = await Provider.of<User>(context, listen: false).updateUser(
          token!,
          username!,
          _changeInformationViewModel.firstName,
          _changeInformationViewModel.lastName,
          _changeInformationViewModel.middleName,
        );

        if (res.status == 200) {
          setState(() {
            _isLoading = false;
          });

          if (!mounted) return;
          Navigator.of(context).pop();
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
  void didChangeDependencies() {
    final models.User? user = Provider.of<User>(context).currentUser;
    if (user != null) {
      setState(() {
        _changeInformationViewModel = _ChangeInformationViewModel(
          firstName: user.firstName,
          middleName: user.middleName,
          lastName: user.lastName,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _middleNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Information',
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
              caption: 'First Name',
              actionButton: TextInputAction.next,
              onTap: _onEnterEditMode,
              focusNode: _firstNameFocusNode,
              initalValue: _changeInformationViewModel.firstName,
              onChange: (_) {},
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(_middleNameFocusNode);
              },
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You have to provide your first name.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changeInformationViewModel = _ChangeInformationViewModel(
                  firstName: value!,
                  middleName: _changeInformationViewModel.middleName,
                  lastName: _changeInformationViewModel.lastName,
                );
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextBox(
              caption: 'Middle Name',
              actionButton: TextInputAction.next,
              onTap: _onEnterEditMode,
              focusNode: _middleNameFocusNode,
              initalValue: _changeInformationViewModel.middleName,
              onChange: (_) {},
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(_lastNameFocusNode);
              },
              onSaved: (String? value) {
                _changeInformationViewModel = _ChangeInformationViewModel(
                  firstName: _changeInformationViewModel.firstName,
                  middleName: value!,
                  lastName: _changeInformationViewModel.lastName,
                );
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextBox(
              caption: 'Last Name',
              actionButton: TextInputAction.done,
              onTap: _onEnterEditMode,
              focusNode: _lastNameFocusNode,
              initalValue: _changeInformationViewModel.lastName,
              onChange: (_) {},
              onSubmit: (_) {},
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You have to provide your last name.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changeInformationViewModel = _ChangeInformationViewModel(
                  firstName: _changeInformationViewModel.firstName,
                  middleName: _changeInformationViewModel.middleName,
                  lastName: value!,
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
