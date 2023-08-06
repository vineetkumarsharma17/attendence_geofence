import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../helper/theme.dart';

showLoading([String text = "Please wait..."]) {
  // TODO : BETTER DESIGN
  Get.defaultDialog(
      backgroundColor: Colors.white, //.withOpacity(1),
      titleStyle: const TextStyle(fontSize: 0),
      title: "",
      content: Column(
        children: [
          SpinKitFadingCube(
            color: AppColors.primary,
            size: 50.0,
          ),
          if (text != null)
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(text)
              ],
            )
        ],
      ),
      // Row(
      //   children: const [
      //     CircularProgressIndicator(),
      //     SizedBox(width: 10,),
      //     Expanded(child: Text('Loading...'))
      //   ],
      // ),
      barrierDismissible: false);
}

dismissLoadingWidget() {
  if (Get.isDialogOpen!) {
    Get.back();
  }
}
