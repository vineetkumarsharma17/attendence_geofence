import 'dart:developer';

import 'package:attendence_geofence/helper/theme.dart';
import 'package:attendence_geofence/views/screens/take_selfie/selfie_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import '../../../controller/main_controller.dart';
import '../../widgets/button.dart';
import '../../widgets/map.dart';

class CheckLocationScreen extends StatefulWidget {
  const CheckLocationScreen({super.key});

  @override
  State<CheckLocationScreen> createState() => _CheckLocationScreenState();
}

class _CheckLocationScreenState extends State<CheckLocationScreen> {
  MainController c = Get.find();
  RxBool isInLocation = false.obs;
  bool isWithinRadius(
      LocationData currentLoc, LatLng targetLoc, double radius) {
    double distance = c.calculateDistance(currentLoc.latitude!,
        currentLoc.longitude!, targetLoc.latitude, targetLoc.longitude);
    print("distance:" + distance.toString());
    return distance <= radius;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text("Set Location")),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ShowMapWidget(
                      selectedArea: c.radius.value,
                      fixedMarkLoc: c.selectedLocation.value,
                      onUpdateLoc: (currentLoc) {
                        log("loc update:");
                        isInLocation.value = isWithinRadius(currentLoc,
                            c.selectedLocation.value!, c.radius.value);
                        log(isWithinRadius(currentLoc,
                                c.selectedLocation.value!, c.radius.value)
                            .toString());
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => ButtonWidget(
                            text: "Check In",
                            bgColor: !isInLocation.value
                                ? AppColors.lightGrey
                                : AppColors.primary,
                            onTap: () {
                              if (isInLocation.value) {
                                Get.to(() => const SelfieScreen());
                              }
                            })),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        child: Obx(() => ButtonWidget(
                            text: "Check Out",
                            bgColor: !isInLocation.value
                                ? AppColors.lightGrey
                                : AppColors.primary,
                            onTap: () {})),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
