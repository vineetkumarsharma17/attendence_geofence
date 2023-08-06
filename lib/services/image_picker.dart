import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage({ImageSource? source, int? imageQuality}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
      source: source ?? ImageSource.camera, imageQuality: imageQuality ?? 50);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

Future<File?> pickImageAndCrop() async {
  final pickedFile = await pickImage();
  if (pickedFile != null) {
    final croppedFile = await ImageCropper()
        .cropImage(sourcePath: pickedFile.path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ]);

    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return null;
    }
  }
  return null;
}
