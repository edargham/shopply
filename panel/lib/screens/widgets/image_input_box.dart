import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopply_admin_panel/screens/widgets/main_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

class ImageInputBox extends StatefulWidget {
  final File? initialFile;
  final Function(File) onImageSelected;
  const ImageInputBox({
    Key? key,
    required this.onImageSelected,
    this.initialFile,
  }) : super(key: key);

  @override
  State<ImageInputBox> createState() => _ImageInputBoxState();
}

class _ImageInputBoxState extends State<ImageInputBox> {
  File? _selectedImage;

  void _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  void _chooseFromGallery() async {
    XFile? pickedImage;
    if (Platform.isIOS || Platform.isAndroid) {
      final ImagePicker picker = ImagePicker();
      pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
    } else {
      const XTypeGroup xtg = XTypeGroup(
        label: 'Images',
        extensions: [
          'png',
          'jpg',
          'jpeg',
          'webp',
        ],
      );

      final List<XFile> files = await FileSelectorPlatform.instance
          .openFiles(acceptedTypeGroups: [xtg]);

      if (files.isNotEmpty) {
        pickedImage = files.first;
      }
    }

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage!.path);
      widget.onImageSelected(_selectedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = (_selectedImage == null && widget.initialFile == null)
        ? MainButton(
            onPressed: _chooseFromGallery,
            icon: Icons.camera,
            title: 'Choose Photo',
          )
        : InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: _chooseFromGallery,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0.64),
                    Theme.of(context).colorScheme.background,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.32),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Image.file(
                (_selectedImage != null)
                    ? _selectedImage!
                    : widget.initialFile!,
                fit: BoxFit.scaleDown,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          );

    return Padding(
      padding: EdgeInsets.all((_selectedImage == null) ? 4.0 : 8.0),
      child: SizedBox(
        height: 512,
        width: double.infinity,
        child: content,
      ),
    );
  }
}
