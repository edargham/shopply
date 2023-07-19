import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String caption;
  final TextInputAction actionButton;
  final Function(String) onChange;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;

  const SearchBox({
    super.key,
    required this.caption,
    required this.onChange,
    this.controller,
    this.actionButton = TextInputAction.done,
    this.focusNode,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8.0),
              child: TextField(
                onTap: onTap,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                textInputAction: actionButton,
                focusNode: focusNode,
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  hintText: caption,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                onChanged: onChange,
              ),
            ),
          )
        ],
      ),
    );
  }
}
