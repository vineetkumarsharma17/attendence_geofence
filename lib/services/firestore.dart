import 'dart:developer';

import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/main_controller.dart';

class FireStoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("userProfiles");
  Future<Map?> createUser(Map<String, dynamic> user) async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .set(user)
          .then((value) => user);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  Future<Map?> updateUser(Map<String, dynamic> user) async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .update(user)
          .then((value) => user);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  Future<Map?> getUser() async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.exists ? value.data() as Map : null);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }
}
