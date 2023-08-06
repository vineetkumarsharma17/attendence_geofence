import 'dart:io';

import 'package:camera/camera.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterProfileScreen extends StatefulWidget {
  const RegisterProfileScreen({super.key});

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
  Rx<File?> selfieImg = Rx<File?>(null);
  late CameraController _cameraController;
  RxBool _isCameraInitialized = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    final picture = await _cameraController.takePicture();
    if (picture != null) selfieImg(File(picture.path));
    // Implement your logic to save, display, or process the picture here.
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();

    if (mounted) {
      _isCameraInitialized(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(
            height: 50,
          ),
          GestureDetector(
            // onTap: _pickImageFromCamera,
            child: Obx(
              () => _isCameraInitialized.value
                  ? CircularProgressIndicator()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: CameraPreview(_cameraController),
                        ),
                        GestureDetector(
                          onTap: _takePicture,
                          child: CircularProfileAvatar(
                            selfieImg.value!
                                .path, // You can provide the image here to preview captured image.
                            radius: 150,
                            backgroundColor: Colors.transparent,
                            child: _cameraController.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio:
                                        _cameraController.value.aspectRatio,
                                    child: CameraPreview(_cameraController),
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}
