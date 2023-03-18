import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextBox extends StatelessWidget {
  final String caption;
  final String? hint;
  final String? initalValue;
  final TextInputAction actionButton;
  final TextInputType inputType;
  final Function(String) onChange;
  final Function(String)? onSubmit;
  final Function(String?)? onSaved;
  final VoidCallback? onTap;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;

  const TextBox({
    super.key,
    required this.caption,
    required this.onChange,
    this.onSubmit,
    this.onSaved,
    this.validator,
    this.hint,
    this.inputType = TextInputType.text,
    this.controller,
    this.actionButton = TextInputAction.done,
    this.focusNode,
    this.initalValue,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            onSaved: onSaved,
            onTap: onTap,
            initialValue: initalValue,
            cursorColor: Theme.of(context).colorScheme.onPrimary,
            textInputAction: actionButton,
            keyboardType: inputType,
            focusNode: focusNode,
            controller: controller,
            onFieldSubmitted: onSubmit,
            maxLines: maxLines,
            validator: validator,
            inputFormatters: (inputType == TextInputType.number)
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: InputDecoration(
              label: Text(
                caption,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color.fromARGB(100, 255, 255, 255),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: onChange,
          )
        ],
      ),
    );
  }
}
