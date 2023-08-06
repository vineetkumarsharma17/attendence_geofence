import 'package:attendence_geofence/controller/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  MainController c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Image.asset(
            "assets/images/S9Ih.gif",
          ),
          GestureDetector(
            onTap: () => c.signInWithGoogle(),
            child: Image.network(
              "https://onymos.com/wp-content/uploads/2020/10/google-signin-button.png",
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
