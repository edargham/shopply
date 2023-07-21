import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/sys_admin.dart' as models;

import '../../providers/authentication.dart';
import '../../providers/sys_admin.dart';

import '../../utilities/string_utils.dart';
import '../widgets/dialogs.dart';
import '../widgets/main_button.dart';
import '../widgets/text_box.dart';

class _ChangeEmailViewModel {
  final String email;

  const _ChangeEmailViewModel({
    required this.email,
  });
}

class ChangeEmailScreen extends StatefulWidget {
  static const String routeName = '/change-email-screen';

  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _emailFocusNode = FocusNode();

  late _ChangeEmailViewModel _changeEmailViewModel =
      const _ChangeEmailViewModel(email: '');

  bool _isEditMode = false;
  bool _isLoading = false;

  void _onEnterEditMode() {
    if (!_isEditMode) {
      setState(() {
        _isEditMode = true;
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
            await Provider.of<SysAdmin>(context, listen: false).updateEmail(
          token!,
          username!,
          _changeEmailViewModel.email,
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
  void didChangeDependencies() {
    final models.SysAdmin? user = Provider.of<SysAdmin>(context).currentUser;
    if (user != null) {
      setState(() {
        _changeEmailViewModel = _ChangeEmailViewModel(
          email: user.email,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Email',
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Enter your new email address below.'
                '\nPlease note you will have to reverify your email address via the link sent to your new email.'
                '\nSome features may be disabled until you verify your email address again.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextBox(
              caption: 'Email',
              actionButton: TextInputAction.done,
              onTap: _onEnterEditMode,
              focusNode: _emailFocusNode,
              initalValue: _changeEmailViewModel.email,
              onChange: (_) {},
              onSubmit: (_) {},
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'You have to provide your email.';
                } else {
                  return null;
                }
              },
              onSaved: (String? value) {
                _changeEmailViewModel = _ChangeEmailViewModel(
                  email: value!,
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
