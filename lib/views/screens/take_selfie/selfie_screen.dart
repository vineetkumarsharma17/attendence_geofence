import 'package:flutter/material.dart';

class SelfieScreen extends StatefulWidget {
  const SelfieScreen({super.key});

  @override
  State<SelfieScreen> createState() => _SelfieScreenState();
}

class _SelfieScreenState extends State<SelfieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selfie")),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [],
      ),
    );
  }
}
