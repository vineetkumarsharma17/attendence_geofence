import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/theme.dart';

showAlertBox(String title, String content, Function()? onConfirm,
    {String? confirmText, String? cancelText, Function()? onCancel}) {
  Get.defaultDialog(
      title: title,
      titlePadding: EdgeInsets.only(top: 20),
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: EdgeInsets.all(20),
        // color: Colors.white38,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: onCancel ?? () => Get.back(),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    cancelText ?? "NO",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onConfirm,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    confirmText ?? "Yes",
                    style: TextStyle(
                        // fontFamily: 'Segoe UI',
                        color: AppColors.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ]),
      ));
}
