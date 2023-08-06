import 'dart:io';

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
