import 'dart:developer';
import 'dart:io';

import 'package:attendence_geofence/services/firebaseStorage.dart';
import 'package:attendence_geofence/views/widgets/button.dart';
import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:camera/camera.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controller/main_controller.dart';
import '../../../helper/permission.dart';

class SelfieScreen extends StatefulWidget {
  const SelfieScreen({super.key});

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  Rx<File?> selfieImg = Rx<File?>(null);
  late CameraController _cameraController;
  RxBool _isCameraInitialized = false.obs;
  MainController c = Get.find();
  final FaceDetector _faceDetector = GoogleMlKit.vision
      .faceDetector(FaceDetectorOptions(enableClassification: true));

  bool _isDetecting = false;
  File? firstImage;
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
    selfieImg(File(picture.path));
    _matchFaces();

    // Implement your logic to save, display, or process the picture here.
  }

  Future<void> _initializeCamera() async {
    firstImage =
        await FirebaseStorageService.downloadFile(c.userDb!.profilePic!);
    log("Addresspath:" + firstImage!.path.toString());
    final cameras = await availableCameras();

    CameraDescription? frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    if (await checkPermission(Permission.camera)) {}

    _cameraController = CameraController(frontCamera, ResolutionPreset.high,
        enableAudio: false);
    await _cameraController.initialize();

    if (mounted) {
      _isCameraInitialized(true);
      // _startFaceDetection();
    }
  }

  Future<List<Face>> _detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    try {
      return await _faceDetector.processImage(inputImage);
    } catch (e) {
      // Error occurred during face detection
      print("Error detecting faces: $e");
      showErrorSnackBar(e.toString());
      return [];
    }
  }

  Future<bool> _compareFaces(
      List<Face> firstFaces, List<Face> secondFaces) async {
    final face1 = firstFaces.first;
    final face2 = secondFaces.first;
    // Here, you can implement your face comparison logic.
    // Compare the facial features of both faces to check if they belong to the same person.
    // This can be done using feature comparison algorithms or a face recognition service.

    // For demonstration purposes, we'll assume the faces match if both images have at least one detected face.
    return firstFaces.isNotEmpty && secondFaces.isNotEmpty;
  }

  Future<void> _matchFaces() async {
    if (selfieImg.value == null || firstImage == null) {
      showErrorSnackBar("Please select two images for comparison.");
      return;
    }

    final firstFaces = await _detectFaces(firstImage!);
    final secondFaces = await _detectFaces(selfieImg.value!);

    final isMatch = await _compareFaces(firstFaces, secondFaces);

    if (isMatch) {
      showSnackBar("Success", "Face matched");
      // print("The faces in the two images match.");
    } else {
      showSnackBar("Success", "Face not matched---------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selfie")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              if (_isCameraInitialized.value == false) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return selfieImg.value == null
                  ? GestureDetector(
                      // onTap: _takePicture,
                      child: CircularProfileAvatar(
                        "", // You can provide the image here to preview captured image.
                        radius: 150,
                        backgroundColor: Colors.black,
                        child: _cameraController != null &&
                                _cameraController.value.isInitialized
                            ? CameraPreview(_cameraController)
                            : Container(),
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(selfieImg.value!, scale: 1),
                      radius: 150);
            }),
            ButtonWidget(
              text: "Click",
              onTap: () {
                if (selfieImg.value == null) {
                  _takePicture();
                } else {
                  selfieImg.value = null;
                  setState(() {
                    log("fsdafas");
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
