import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/utilis/my_string.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/auth/auth_button.dart';
import 'package:road_damage/view/widgets/auth/auth_text_from_field.dart';
import 'package:road_damage/view/widgets/auth/check_widget.dart';
import 'package:road_damage/view/widgets/auth/container_under.dart';
import 'package:road_damage/view/widgets/dark_button.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final fromKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
            // ignore: prefer_const_literals_to_create_immutables
            actions: [
              // ignore: prefer_const_constructors
              DarkButton()
            ],
            elevation: 0,
          ),
          backgroundColor: context.theme.backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 1.32,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Form(
                        key: fromKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TextUtils(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  text: "Sign".tr,
                                  color:
                                      Get.isDarkMode ? darkColor2 : mainColor,
                                  underLine: TextDecoration.none,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                TextUtils(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  text: "up".tr,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  underLine: TextDecoration.none,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(
                              flex: 0,
                              child: AuthTextFromField(
                                controller: nameController,
                                obscureText: false,
                                validator: (value) {
                                  if (value.toString().length <= 2 ||
                                      !RegExp(validationName).hasMatch(value)) {
                                    return 'Enter valid name'.tr;
                                  } else {
                                    return null;
                                  }
                                },
                                prefixIcon: Get.isDarkMode
                                    ? const Icon(
                                        Icons.person,
                                        color: darkColor2,
                                        size: 30,
                                      )
                                    : const Icon(Icons.person,
                                        color: mainColor, size: 30),
                                suffixIcon: const Text(""),
                                hintText: 'User Name'.tr,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              flex: 0,
                              child: AuthTextFromField(
                                controller: emailController,
                                obscureText: false,
                                validator: (value) {
                                  if (!RegExp(validationEmail)
                                      .hasMatch(value)) {
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
                                    : const Icon(
                                        Icons.email,
                                        color: mainColor,
                                        size: 30,
                                      ),
                                suffixIcon: const Text(""),
                                hintText: 'Email'.tr,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GetBuilder<AuthController>(
                              builder: (_) {
                                return AuthTextFromField(
                                  controller: passwordController,
                                  obscureText:
                                      controller.isVisibility ? false : true,
                                  validator: (value) {
                                    if (value.toString().length < 6) {
                                      return 'Password should be longer or equal to 6 characters'
                                          .tr;
                                    }
                                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                                      return 'Password must contain at least one lowercase letter'
                                          .tr;
                                    }
                                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                      return 'Password must contain at least one Uppercase letter'
                                          .tr;
                                    }
                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      return 'Password must contain Digits 0,1,2,..'
                                          .tr;
                                    }
                                    if (!RegExp(r'[!@#$%^&*(),.?;":{}|<>]')
                                        .hasMatch(value)) {
                                      return 'Password must contain symbols !@#%^&.. '
                                          .tr;
                                    }
                                    // if (isPasswordCompliant == false) {
                                    //   return 'Password should be longer or equal to 6 characters';
                                    // }
                                    else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Get.isDarkMode
                                      ? const Icon(
                                          Icons.lock,
                                          color: darkColor2,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.lock,
                                          color: mainColor,
                                          size: 30,
                                        ),
                                  hintText: 'Password'.tr,
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
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Expanded(flex: 0, child: CheckWidget()),
                            const SizedBox(
                              height: 30,
                            ),
                            GetBuilder<AuthController>(
                              builder: (_) {
                                return AuthButton(
                                  onPressed: () {
                                    if (controller.isCheckBox == false) {
                                      Get.snackbar(
                                        "Check Box".tr,
                                        "Please, Accept terms & conditions".tr,
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Get.isDarkMode
                                            ? darkGreyClr
                                            : Colors.white,
                                        colorText: darkColor2,
                                      );
                                    } else if (fromKey.currentState!
                                        .validate()) {
                                      String name = nameController.text.trim();
                                      String email =
                                          emailController.text.trim();
                                      String password = passwordController.text;
                                      networkManager.connectionType == 0
                                          ? Get.snackbar('Error !'.tr,
                                              'Failed connect to internet'.tr,
                                              icon: const ImageIcon(
                                                AssetImage(
                                                    "assets/icons/no-connection.png"),
                                                color: Colors.red,
                                              ))
                                          : controller.signUpUsingAws(
                                              name: name,
                                              email: email,
                                              password: password,
                                            );
                                      controller.isCheckBox = true;
                                    }
                                  },
                                  text: "Sign up".tr,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            elevation: 0,
            child: ContainerUnder(
              text: "Already have an Account? ".tr,
              textType: "LOG IN".tr,
              onPressed: () {
                Get.offNamed(Routes.loginScreen);
              },
            ),
          )),
    );
  }
}
