import 'dart:developer';

import 'package:attendence_geofence/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import '../../helper/permission.dart';

class ShowMapWidget extends StatefulWidget {
  ShowMapWidget(
      {super.key,
      this.onTap,
      required this.selectedArea,
      this.onReset,
      this.fixedMarkLoc,
      this.onUpdateLoc});

  final void Function(LatLng)? onTap;
  final void Function()? onReset;
  final void Function(LocationData)? onUpdateLoc;
  final double selectedArea;
  final LatLng? fixedMarkLoc;

  @override
  State<ShowMapWidget> createState() => _ShowMapWidgetState();
}

class _ShowMapWidgetState extends State<ShowMapWidget> {
  MapController _mapController = MapController();
  Rx<LocationData?> _currentLocation = Rx<LocationData?>(null);
  LatLng? markedLatLong;
  Location _locationService = Location();
  Future<void> getCurrentLocation({bool isCenterAlign = false}) async {
    markedLatLong = null;
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if the app has location permissions
    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        checkPermission(permission.Permission.location);
        return;
      }
    }

    // Get the current location

    _locationService.onLocationChanged.listen((LocationData result) {
      // log(result.toString());
      _currentLocation.value = result;
      try {
        if (isCenterAlign) {
          _mapController.move(
              LatLng(result.latitude!, result.longitude!), 15.0);
        }
      } catch (e) {
        log("error:" + e.toString());
        getCurrentLocation();
      }

      if (widget.onUpdateLoc != null) widget.onUpdateLoc!(result);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    if (widget.fixedMarkLoc != null) {
      markedLatLong = widget.fixedMarkLoc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                BoxDecoration(border: Border.all(color: AppColors.grey)),
            height: Get.height * .4,
            child: Obx(() => _currentLocation.value == null
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Please Wait..."),
                        SizedBox(
                          height: 20,
                        ),
                        CircularProgressIndicator()
                      ],
                    ),
                  )
                : FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      center: LatLng(_currentLocation.value!.latitude!,
                          _currentLocation.value!.longitude!),
                      onTap: (tapPosition, point) {
                        if (widget.onTap != null) {
                          setState(() {
                            markedLatLong = point;
                          });
                          widget.onTap!(point);
                        }
                      },
                      zoom: 15.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.attendence.vSafe',
                        subdomains: ['a', 'b', 'c'],
                        maxZoom: 19,
                      ),
                      CurrentLocationLayer(), // <-- add layer here
                      CircleLayer(
                        circles: [
                          CircleMarker(
                              point: markedLatLong ??
                                  LatLng(_currentLocation.value!.latitude!,
                                      _currentLocation.value!.longitude!),
                              radius: widget.selectedArea,
                              color: const Color.fromARGB(255, 166, 199, 225)
                                  .withOpacity(0.4),
                              borderColor: Colors.blue,
                              borderStrokeWidth: 2,
                              useRadiusInMeter: true),
                        ],
                      ),
                      if (markedLatLong !=
                          null) // Show the marker only if it's tapped
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 30.0,
                              height: 30.0,
                              point: markedLatLong!,
                              builder: (ctx) => const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ))),
        Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  _mapController.move(
                      LatLng(_currentLocation.value!.latitude!,
                          _currentLocation.value!.longitude!),
                      15.0);
                  if (widget.fixedMarkLoc == null) markedLatLong = null;
                  // getCurrentLocation();
                }),
                if (widget.onReset != null) {widget.onReset!()}
              },
              child: CircleAvatar(
                backgroundColor: AppColors.grey,
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ))
      ],
    );
  }
}
