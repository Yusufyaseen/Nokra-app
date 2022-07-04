import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';
import 'package:road_damage/logic/controller/theme_controller.dart';
import 'package:road_damage/logic/controller/userData_controller.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/home/arrow_back.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  MainDrawer({Key? key}) : super(key: key);
  final userController = Get.find<User_controller>();
  String userName = '....';
  final controller = Get.find<AuthController>();
  final languageController = Get.find<LanguageController>();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    bool isAdmin = box.read('isAdmin');
    return GetBuilder<User_controller>(builder: (_) {
      return Stack(
        children: [
          Column(children: [
            Padding(
              padding:
                  EdgeInsets.only(top: height * 0.07, bottom: height * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => userController
                        .uploadImage(userController.identifier['sub']),
                    child: userController.first
                        ? CircleAvatar(
                            radius: width * 0.14,
                            backgroundImage:
                                const AssetImage('assets/images/profile.png'),
                          )
                        : CircleAvatar(
                            radius: width * 0.14,
                            backgroundImage:
                                FileImage(userController.authUserPhoto),
                          ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Text(
                    "Hello ".tr,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Text(
                    userController.identifier['name'] + '👋🏻' ?? userName,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            isAdmin
                ? ListTile(
                    onTap: () => Get.toNamed(Routes.appdata),
                    leading: const Icon(
                      Icons.data_object,
                      color: Colors.black,
                    ),
                    title: Text("App Data".tr),
                    trailing: ArrowBack(),
                  )
                : Container(),
            // ListTile(
            //   onTap: () => Get.to(PageViewInit()),
            //   leading: CircleAvatar(
            //       backgroundColor: Get.isDarkMode ? darkColor : mainColor,
            //       child: const Icon(
            //         Icons.location_on,
            //         color: lightColor,
            //       )),
            //   title: Text("test"),
            //   trailing: ArrowBack(),
            // ),
            ListTile(
              onTap: () => Get.toNamed(Routes.maps),
              leading: CircleAvatar(
                  backgroundColor: Get.isDarkMode ? darkColor : mainColor,
                  child: const Icon(
                    Icons.location_on,
                    color: lightColor,
                  )),
              title: Text("Maps".tr),
              trailing: ArrowBack(),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: TextUtils(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    text: 'Account'.tr,
                    color: Get.isDarkMode ? darkColor2 : mainColor,
                    underLine: TextDecoration.none),
              ),
            ),
            ListTile(
              onTap: () => Get.toNamed(Routes.profileScreen),
              leading: CircleAvatar(
                  backgroundColor: Get.isDarkMode ? Colors.black26 : lightColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  )),
              title: Text("Your Profile".tr),
              trailing: ArrowBack(),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: TextUtils(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    text: 'Settings'.tr,
                    color: Get.isDarkMode ? darkColor2 : mainColor,
                    underLine: TextDecoration.none),
              ),
            ),
            ListTile(
              onTap: ThemeController().changesTheme,
              leading: CircleAvatar(
                backgroundColor: Get.isDarkMode ? darkColor : mainColor,
                child: Icon(
                  Get.isDarkMode ? Icons.dark_mode : Icons.lightbulb_outline,
                  color: lightColor,
                ),
              ),
              title: Text("Dark Mode".tr),
              trailing: Text(Get.isDarkMode ? 'on'.tr : 'off'.tr),
            ),
            GetBuilder<LanguageController>(
                builder: (_) => ListTile(
                      onTap: languageController.changeLanguage,
                      leading: CircleAvatar(
                          backgroundColor:
                              Get.isDarkMode ? lightColor3 : lightColor4,
                          child: const Icon(
                            Icons.language_rounded,
                            color: Colors.black,
                          )),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Language".tr),
                            Text(
                              languageController.isLang ? 'العربيه' : 'English',
                              style: TextStyle(
                                  color:
                                      Get.isDarkMode ? darkColor2 : mainColor),
                            ),
                          ]),
                      trailing: ArrowBack(),
                    )),
          ]),
          Container(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              onTap: controller.signout,
              leading: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  )),
              title: Text("Log Out".tr),
            ),
          )
        ],
      );
    });
  }
}
