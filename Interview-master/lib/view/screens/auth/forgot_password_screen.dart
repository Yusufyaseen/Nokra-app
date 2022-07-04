import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/utilis/my_string.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/auth/auth_button.dart';
import 'package:road_damage/view/widgets/auth/auth_text_from_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
          centerTitle: true,
          elevation: 0.2,
          title: Text(
            'Forgot Password'.tr,
            style: TextStyle(
              color: Get.isDarkMode ? darkColor2 : mainColor,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : mainColor,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.08,
                  ),
                  Text(
                    'If you want to recover your account, then please provide your email ID below..'
                        .tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Get.isDarkMode
                      ? Image.asset(
                          'assets/icons/ForgetPaswordDark.png',
                          width: 250,
                        )
                      : Image.asset(
                          'assets/icons/forgetpass.png',
                          width: 250,
                        ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  AuthTextFromField(
                    controller: emailController,
                    obscureText: false,
                    validator: (value) {
                      if (!RegExp(validationEmail).hasMatch(value)) {
                        return 'Invalid email'.tr;
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: Get.isDarkMode
                        ? const Icon(
                            Icons.email,
                            color: darkColor2,
                            size: 30,
                          )
                        : const ImageIcon(
                            AssetImage("assets/icons/email.png"),
                            color: mainColor,
                          ),
                    suffixIcon: const Text(""),
                    hintText: 'Email'.tr,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  GetBuilder<AuthController>(builder: (_) {
                    return AuthButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String email = emailController.text.trim();
                          networkManager.connectionType == 0
                              ? Get.snackbar(
                                  'Error !'.tr,
                                  'Failed connect to internet'.tr,
                                  icon: const ImageIcon(
                                    AssetImage(
                                        "assets/icons/no-connection.png"),
                                    color: Colors.red,
                                  ),
                                )
                              : controller.resetPassword(email: email);
                        }
                      },
                      text: "SEND".tr,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
