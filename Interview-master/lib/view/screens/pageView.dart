// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:road_damage/routes/routes.dart';
import '../widgets/text_utils.dart';
import '../../utilis/theme.dart';

class PageViewInit extends StatelessWidget {
  PageViewInit({Key? key}) : super(key: key);
  PageViewModel p1 = PageViewModel(
    titleWidget: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextUtils(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          text: "N".tr,
          color: Get.isDarkMode ? darkColor2 : mainColor,
          underLine: TextDecoration.none,
        ),
        const SizedBox(
          width: 7,
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: Get.isDarkMode ? darkColor2 : Colors.teal,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Get.isDarkMode ? Colors.white : lightColor,
            child: ImageIcon(
              const AssetImage("assets/icons/pothole.png"),
              size: 30,
              color: Get.isDarkMode ? darkColor2 : mainColor,
            ),
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        TextUtils(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          text: "KRA".tr,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
          underLine: TextDecoration.none,
        ),
      ],
    ),
    bodyWidget: Text(
      "Nokra aims to find the most convenient way with the fewest number of anomalies."
          .tr,
      style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2),
      textAlign: TextAlign.center,
    ),
    image: Image.asset(
      'assets/images/page4.jpg',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    ),
    decoration: const PageDecoration(imageFlex: 2),
  );
  PageViewModel p2 = PageViewModel(
    titleWidget: Text("It's a Smart Solution".tr,
        style: TextStyle(
            fontSize: 30,
            color: Colors.grey[500],
            fontWeight: FontWeight.w600)),
    bodyWidget: Container(),
    footer: Text(
      'Nokra helps those responsible for repairing roads find places of anomalies easily.'
          .tr,
      style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2),
      textAlign: TextAlign.center,
    ),
    decoration: const PageDecoration(imageFlex: 1, bodyFlex: 1),
    image: Image.asset(
      'assets/images/page6.jpg',
      fit: BoxFit.cover,
      // width: double.infinity,
      height: double.infinity,
    ),
  );
  PageViewModel p3 = PageViewModel(
    titleWidget: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextUtils(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          text: "N".tr,
          color: Get.isDarkMode ? darkColor2 : mainColor,
          underLine: TextDecoration.none,
        ),
        const SizedBox(
          width: 7,
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: Get.isDarkMode ? darkColor2 : Colors.teal,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Get.isDarkMode ? Colors.white : lightColor,
            child: ImageIcon(
              const AssetImage("assets/icons/pothole.png"),
              size: 30,
              color: Get.isDarkMode ? darkColor2 : mainColor,
            ),
          ),
        ),
        const SizedBox(
          width: 7,
        ),
        TextUtils(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          text: "KRA".tr,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
          underLine: TextDecoration.none,
        ),
      ],
    ),
    bodyWidget: Text(
      'Nokra reveals anomalies locations on the map for more safety for drivers.'
          .tr,
      style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2),
      textAlign: TextAlign.center,
    ),
    decoration: const PageDecoration(imageFlex: 1),
    image: Image.asset(
      'assets/images/page5.jpg',
      fit: BoxFit.cover,
      // width: double.infinity,
      height: double.infinity,
    ),
    footer: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Get.isDarkMode ? darkColor2 : mainColor,
          fixedSize: Size.infinite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          await GetStorage().write('page', true);
          Get.offNamed(Routes.loginScreen);
        },
        child: Center(
          child: TextUtils(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            text: 'Get Started'.tr,
            color: Colors.white,
            underLine: TextDecoration.none,
          ),
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: IntroductionScreen(
            pages: [p1, p2, p3],
            onDone: () {
              // When done button is press
            },

            back: Text(
              "Prev".tr,
              style: TextStyle(color: Get.isDarkMode ? darkColor2 : mainColor),
            ),
            showBackButton: true,
            showSkipButton: false,
            // next: const Icon(Icons.arrow_forward_ios ),
            next: Text(
              "Next".tr,
              style: TextStyle(color: Get.isDarkMode ? darkColor2 : mainColor),
            ),
            done: Container(),
            dotsDecorator: DotsDecorator(
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeColor: Get.isDarkMode ? darkColor2 : mainColor,
                color: Colors.black26,
                spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
          ),
        ),
      ),
    );
  }
}
