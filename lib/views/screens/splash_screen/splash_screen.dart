import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text("Splash Screen"),
          const CircularProgressIndicator()
        ],
        mainAxisSize: MainAxisSize.min,
      )),
    );
  }
}
