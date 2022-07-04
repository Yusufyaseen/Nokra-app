// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/dark_button.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
        actions: [
          // ignore: prefer_const_constructors
          DarkButton(),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Get.isDarkMode ? darkGreyClr : Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
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
                        backgroundColor:
                            Get.isDarkMode ? darkColor2 : Colors.teal,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: ImageIcon(
                            const AssetImage("assets/icons/pothole.png"),
                            size: double.infinity,
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
                  const SizedBox(
                    height: 250,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Get.isDarkMode ? darkColor2 : mainColor,
                        fixedSize: Size.infinite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        )),
                    onPressed: () {
                      Get.offNamed(Routes.loginScreen);
                    },
                    child: TextUtils(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      text: 'Get Start'.tr,
                      color: Colors.white,
                      underLine: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextUtils(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    text: "Don't have an Account?".tr,
                    color: Get.isDarkMode ? darkColor2 : mainColor,
                    underLine: TextDecoration.none,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamed(Routes.signUpScreen);
                    },
                    child: TextUtils(
                      text: 'Sign Up'.tr,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      underLine: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
