import 'package:attendence_geofence/controller/main_controller.dart';
import 'package:get/get.dart';

class AllBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<MainController>(MainController(), permanent: true);
  }
}
