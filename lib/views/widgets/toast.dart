import 'package:get/get.dart';

showSnackBar(String title, String message) {
  Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
}

showErrorSnackBar(String message) {
  Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
}
