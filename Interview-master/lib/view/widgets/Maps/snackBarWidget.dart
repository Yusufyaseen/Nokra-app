import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/maps/textFieldController.dart';

class SnackBars {
  static TextFieldController tc = Get.put(TextFieldController());

  static void potholeSnackBar2() {
    Get.snackbar(
      "Watch Out!".tr,
      "There is a pothole is near to you.".tr,
      icon: const ImageIcon(
        AssetImage("assets/icons/pothole.png"),
        color: Colors.red,
      ),
    );
  }

  static void repeatedSnackBar() {
    Get.snackbar(
      "Watch Out!".tr,
      "That is a rough road.".tr,
      icon: const ImageIcon(
        AssetImage("assets/icons/pothole.png"),
        color: Colors.red,
      ),
    );
  }

  static void nothingSnackBar() {
    Get.snackbar(
      "Nothing",
      "You did not choose location!",
      duration: const Duration(seconds: 2),
      titleText: Text(
        "Nothing".tr,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      messageText: Text(
        "You did not choose location!".tr,
        style: const TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300),
      ),
      backgroundColor: Colors.brown[700],
      borderRadius: 10,
    );
  }

  static void networkSnackBar() {
    Get.snackbar(
      'Error !'.tr,
      'Failed connection to internet'.tr,
      icon: const ImageIcon(
        AssetImage("assets/icons/no-connection.png"),
        color: Colors.red,
      ),
    );
  }
  // static void networkSnackBar(e) {
  //   Get.snackbar(
  //     'Error !'.tr,
  //     'Failed connect to internet'.tr,
  //     icon: const ImageIcon(
  //       AssetImage(
  //           "assets/icons/no-connection.png"),
  //       color: Colors.red,
  //     ),
  //   );
  // }

}
