import 'dart:io';

import 'package:attendence_geofence/controller/main_controller.dart';
import 'package:attendence_geofence/helper/permission.dart';
import 'package:attendence_geofence/services/image_picker.dart';
import 'package:attendence_geofence/views/widgets/button.dart';
import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:camera/camera.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helper/theme.dart';

class RegisterProfileScreen extends StatefulWidget {
  const RegisterProfileScreen({super.key});

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
  Rx<File?> selfieImg = Rx<File?>(null);
  late CameraController _cameraController;
  RxBool _isCameraInitialized = false.obs;
  MainController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular container with profile picture
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.lightGrey),
                          image: selfieImg.value != null
                              ? DecorationImage(
                                  image: FileImage(selfieImg.value!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: selfieImg.value == null
                            ? const Icon(
                                Icons.person,
                                size: 100,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      // Camera icon button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () async {
                            selfieImg(await pickImageAndCrop());
                          },
                          icon: const CircleAvatar(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              ButtonWidget(
                  text: "Upload",
                  onTap: () {
                    if (selfieImg.value == null) {
                      showErrorSnackBar("Please Click Image");
                      return;
                    }
                    c.registerUser(selfieImg.value!);
                  })
            ],
          ),
        )
        // Obx(
        //   () => !_isCameraInitialized.value
        //       ? Center(child: CircularProgressIndicator())
        //       : selfieImg.value == null
        //           ? GestureDetector(
        //               onTap: _takePicture,
        //               child: CircularProfileAvatar(
        //                 "", // You can provide the image here to preview captured image.
        //                 radius: 150,
        //                 backgroundColor: Colors.black,
        //                 child: _cameraController.value.isInitialized
        //                     ? CameraPreview(_cameraController)
        //                     : Container(),
        //               ),
        //             )
        //           : CircleAvatar(
        //               backgroundImage: FileImage(selfieImg.value!, scale: 1),
        //               radius: 150),
        // ),
        //   ],
        // ),
        );
  }
}
