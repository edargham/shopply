import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/view_models/user.dart' as models;

import '../../providers/user.dart';

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

  @override
  void initState() {
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
    super.initState();
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
    final models.User? user = Provider.of<User>(context).currentUser;
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
      body: ListView(
        children: <Widget>[],
      ),
    );
  }
}
