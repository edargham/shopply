import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextBox extends StatelessWidget {
  final String caption;
  final String? hint;
  final TextInputAction actionButton;
  final TextInputType inputType;
  final Function(String) onChange;
  final Function(String)? onSubmit;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;

  const TextBox({
    super.key,
    required this.caption,
    required this.onChange,
    this.onSubmit,
    this.hint,
    this.inputType = TextInputType.text,
    this.controller,
    this.actionButton = TextInputAction.done,
    this.focusNode,
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
            textInputAction: actionButton,
            keyboardType: inputType,
            focusNode: focusNode,
            controller: controller,
            onFieldSubmitted: onSubmit,
            maxLines: maxLines,
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
