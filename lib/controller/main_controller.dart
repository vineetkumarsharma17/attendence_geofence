import 'dart:math';

import 'package:attendence_geofence/views/screens/auth_screens/log_in_screen.dart';
import 'package:attendence_geofence/views/screens/auth_screens/register_profile.dart';
import 'package:attendence_geofence/views/screens/create_location/create_loc.dart';
import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/widgets/loading.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class MainController extends GetxController {
  Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  RxDouble radius = 10.0.obs;
  // RxMap dbUser

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      auth.userChanges().listen((user) {
        if (user == null) {
          Get.offAll(() => LogInScreen());
        } else {
          Get.offAll(() => const RegisterProfileScreen());
        }
      });
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int radiusOfEarth = 6371000; // Earth's radius in kilometers
    double lat1Radians = degreesToRadians(lat1);
    double lon1Radians = degreesToRadians(lon1);
    double lat2Radians = degreesToRadians(lat2);
    double lon2Radians = degreesToRadians(lon2);

    double dLat = lat2Radians - lat1Radians;
    double dLon = lon2Radians - lon1Radians;

    double a = pow(sin(dLat / 2), 2) +
        cos(lat1Radians) * cos(lat2Radians) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    print("dddd:$c");
    return radiusOfEarth * c;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      showLoading();
      var account = await _googleSignIn.signIn();
      if (account != null) {
        var googleKey = await account.authentication;
        var credential = GoogleAuthProvider.credential(
          accessToken: googleKey.accessToken,
          idToken: googleKey.idToken,
        );
        await auth.signInWithCredential(credential).then((value) {
          dismissLoadingWidget();
          showSnackBar("Success", "Signed In Successfully.");
        }).onError((e, stackTrace) {
          print("Error: $e");
          dismissLoadingWidget();
          if (e is FirebaseAuthException) {
            showSnackBar("Error", e.message!);
          } else {
            showSnackBar("Error", e.toString());
          }
        });
      }
    } catch (error) {
      dismissLoadingWidget();
      print("Catch Error: $error");
      showSnackBar("Error", error.toString());
    }
  }
}
