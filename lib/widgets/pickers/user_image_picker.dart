import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) pickImageFn;
  UserImagePicker(this.pickImageFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _imageFIle;
  //Pick image function
  void _pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    setState(() {
      _imageFIle = File(pickedFile!.path);
    });
    widget.pickImageFn(_imageFIle!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _imageFIle == null ? null : FileImage(_imageFIle!),
            radius: 40,
          ),
          TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add a picture'),
          ),
        ],
      ),
    );
  }
}
