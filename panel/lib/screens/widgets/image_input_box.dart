import 'package:flutter/material.dart';
import 'package:shopply_admin_panel/screens/widgets/main_button.dart';

class ImageInputBox extends StatefulWidget {
  const ImageInputBox({Key? key}) : super(key: key);

  @override
  State<ImageInputBox> createState() => _ImageInputBoxState();
}

void _openCamera() {}

void _chooseFromGallery() {}

class _ImageInputBoxState extends State<ImageInputBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 256,
        width: double.infinity,
        child: MainButton(
          onPressed: () {},
          icon: Icons.camera,
          title: 'Choose Photo',
        ),
      ),
    );
  }
}
