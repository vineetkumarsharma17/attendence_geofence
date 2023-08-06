import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {
  static Future<String?> uploadFile(
    String path,
    String fileName, {
    required File file,
  }) async {
    try {
      return FirebaseStorage.instance
          .ref(path)
          .child(fileName)
          .putFile(file)
          .then((value) => value.ref.getDownloadURL());
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  static Future<List?> uploadMultiFile(
    String path, {
    List<File>? files,
    List<Map<String, dynamic>>? byteList,
  }) async {
    try {
      var imageUrls = await Future.wait(files!.map(
          (file) => uploadFile(path, file.path.split('/').last, file: file)));
      return imageUrls.where((element) => element != null).toList();
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  static Future<bool?> deleteFileByUrl(String url) async {
    try {
      return await FirebaseStorage.instance
          .refFromURL(url)
          .delete()
          .then((value) => true);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  static Future<bool?> deleteMultiFileByUrl(List<String> urls) async {
    try {
      return await Future.wait(urls.map((url) => deleteFileByUrl(url)))
          .then((value) => true);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  static Future<File?> downloadFile(String url) async {
    try {
      String name = getFileNameFromUrl(url);
      Directory appDocDir = await getTemporaryDirectory();
      String appDocPath = appDocDir.path;
      String filePath = '$appDocPath/img.jpg';
      log(filePath);
      final File file = File(filePath);
      await FirebaseStorage.instance.refFromURL(url).writeToFile(file);
      return file;
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  static String getFileNameFromUrl(String url) {
    Uri uri = Uri.parse(url);
    String filePath = uri.path;
    String fileName = filePath.split('/').last;
    // if (url != null) {
    //   Uri uri = Uri.parse(url);
    log("url" + uri.toString());
    //   dev.log("url" + uri.pathSegments.toString());
    //   fileName = uri.pathSegments.last;
    // }
    return fileName;
  }
}
