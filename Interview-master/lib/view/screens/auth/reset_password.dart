import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/auth/auth_text_from_field.dart';

// ignore: camel_case_types
class resetPassword extends StatelessWidget {
  resetPassword({Key? key}) : super(key: key);
  final TextEditingController passwordController = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  final email = Get.arguments['email'];
  @override
  Widget build(BuildContext context) {
    return controller.isLoad
        ? const CircularProgressIndicator()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: context.theme.backgroundColor,
            appBar: AppBar(
              title: Text('Change password'.tr),
              backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                child: Form(
                  key: fromKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.lightGreen.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/icons/verification-email.png',
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GetBuilder<AuthController>(builder: (_) {
                        return AuthTextFromField(
                          controller: passwordController,
                          obscureText: controller.isVisibility ? false : true,
                          validator: (value) {
                            if (value.toString().length < 6) {
                              return 'Password should be longer or equal to 6 characters'
                                  .tr;
                            } else {
                              return null;
                            }
                          },
                          prefixIcon: Get.isDarkMode
                              ? const Icon(
                                  Icons.lock,
                                  color: darkColor2,
                                  size: 30,
                                )
                              : const ImageIcon(
                                  AssetImage("assets/icons/lock.png"),
                                  color: mainColor,
                                ),
                          hintText: 'Enter new Password'.tr,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.visibility();
                            },
                            icon: controller.isVisibility
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Enter your confirmation code number".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : darkGreyClr,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Didn't you receive any code?".tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? darkColor : mainColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )),
            ),
          );
  }
}
