import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

import '../views/widgets/alertBox.dart';

Future<bool> checkPermission(Permission permission) async {
  log("permission:" + permission.toString());
  String permissionName = permission.toString().split('.').last.toUpperCase();

  PermissionStatus status = await permission.request();
  log("status: $status");
  if (status.isGranted) {
    return true;
  }
  if (status.isPermanentlyDenied || status.isDenied) {
    showAlertBox("Permission Required!",
        "You need to allow $permissionName permission for a better experience.",
        () {
      openAppSettings();
    }, cancelText: "Close", confirmText: "Open Setting");
  }

  return false;
}
