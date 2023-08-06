import 'dart:developer';

import 'package:attendence_geofence/views/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/main_controller.dart';
import '../models/use_model.dart';

class FireStoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("userProfiles");
  final CollectionReference _locationCollectionReference =
      FirebaseFirestore.instance.collection("location");
  Future<UserDb?> createUser(UserDb user) async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .set(user.toJson())
          .then((value) => user);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  Future<UserDb?> updateUser(UserDb user) async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .update(user.toJson())
          .then((value) => user);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  Future<UserDb?> getUser() async {
    try {
      return await _usersCollectionReference
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) => value.exists
              ? UserDb.fromJson(value.data() as Map<String, dynamic>)
              : null);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }

  // set location an radius to server
  Future<Map?> setLocation(Map data) async {
    try {
      return await _locationCollectionReference
          .doc('location')
          .set(data)
          .then((value) => data);
    } catch (e) {
      log(" Catch Error: $e");
      showErrorSnackBar(e.toString());
      return null;
    }
  }
}
