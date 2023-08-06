import 'dart:developer';

import 'package:attendence_geofence/controller/main_controller.dart';
import 'package:attendence_geofence/views/screens/mark_attendence/check_loc.dart';
import 'package:attendence_geofence/views/widgets/button.dart';
import 'package:attendence_geofence/views/widgets/map.dart';
import 'package:attendence_geofence/views/widgets/textfield.dart';
import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart'; // Add this for lat-long handling
import 'package:location/location.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../../../helper/permission.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  MainController c = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double selectedArea = 10; // in meter
  LatLng? markedLatLong;
  TextEditingController radiusCtrl = TextEditingController(text: "10");

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
                  markedLatLong == null
                      ? const Text("Click to mark location")
                      : Text(
                          "Latitude:${markedLatLong!.latitude}  Longitude:${markedLatLong!.longitude}"),
                  const SizedBox(
                    height: 10,
                  ),
                  ShowMapWidget(
                      selectedArea: selectedArea,
                      onTap: (p0) {
                        setState(() {
                          markedLatLong = p0;
                        });
                      },
                      onReset: () {}),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextField(
                    ctrl: radiusCtrl,
                    hintText: " Radius (in meter)",
                    width: 200,
                    onChanged: (p0) => setState(() {
                      if (p0.isNotEmpty && double.parse(p0) > 10) {
                        selectedArea = double.parse(p0);
                      }
                    }),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ButtonWidget(
                      text: "Save Location",
                      onTap: () {
                        if (markedLatLong != null) {
                          c.selectedLocation(markedLatLong);
                          c.radius(selectedArea);
                          Get.to(() => const CheckLocationScreen());
                        } else {
                          showSnackBar("Error", "Please mark a location.");
                        }
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
