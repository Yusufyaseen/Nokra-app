import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

import '../../../logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';
import '../../../logic/controller/userData_controller.dart';
import '../../../utilis/theme.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final userController = Get.find<User_controller>();
  String userName = '....';
  final controller = Get.find<AuthController>();
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
          elevation: 0,
          centerTitle: true,
          title: TextUtils(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              text: 'Account'.tr,
              color: Get.isDarkMode ? lightColor : mainColor,
              underLine: TextDecoration.none),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? lightColor : darkGreyClr,
            ),
          ),
        ),
        body: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('photo'),
            ),
            GetBuilder<User_controller>(builder: (_) {
              return Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: height * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => userController.uploadImage(
                                  userController.identifier['sub']),
                              child: userController.first
                                  ? CircleAvatar(
                                      radius: width * 0.25,
                                      backgroundImage: const AssetImage(
                                          'assets/images/profile.png'),
                                    )
                                  : CircleAvatar(
                                      radius: width * 0.25,
                                      backgroundImage: FileImage(
                                          userController.authUserPhoto),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.015,
                      ),
                      Center(
                        child: GestureDetector(
                            onTap: () => userController
                                .uploadImage(userController.identifier['sub']),
                            child: TextUtils(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                text: 'Upload Image'.tr,
                                color: Get.isDarkMode ? darkColor : mainColor,
                                underLine: TextDecoration.underline)),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40.0, left: 5, right: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextUtils(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              text: 'User Name'.tr,
                              color: Get.isDarkMode ? lightColor : darkGreyClr,
                              underLine: TextDecoration.none),
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Container(
                            width: width * 0.6,
                            padding: const EdgeInsets.only(
                              //using bottom property, can control the space between underline and text
                              bottom: 7,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                userController.identifier['name'] ?? userName,
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Get.isDarkMode ? lightColor : darkGreyClr,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40.0, left: 5, right: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextUtils(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              text: 'User Email'.tr,
                              color: Get.isDarkMode ? lightColor : darkGreyClr,
                              underLine: TextDecoration.none),
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Container(
                            width: width * 0.6,
                            padding: const EdgeInsets.only(
                              //using bottom property, can control the space between underline and text
                              bottom: 7,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                userController.identifier['email'] ?? userName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Get.isDarkMode ? lightColor : darkGreyClr,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40.0, left: 5, right: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextUtils(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              text: 'Password'.tr,
                              color: Get.isDarkMode ? lightColor : darkGreyClr,
                              underLine: TextDecoration.none),
                          SizedBox(
                            width: width * 0.1,
                          ),
                          Container(
                            width: width * 0.6,
                            padding: const EdgeInsets.only(
                              //using bottom property, can control the space between underline and text
                              bottom: 7,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(Routes.forgetPassScreen),
                                  child: Text(
                                    '********',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Get.isDarkMode
                                          ? lightColor
                                          : darkGreyClr,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.edit)
                              ],
                            ),
                          ),
                        ]),
                  )
                ],
              );
            }),
          ],
        ));
  }
}
