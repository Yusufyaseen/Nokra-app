import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/routes/routes.dart';
import 'package:road_damage/utilis/my_string.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/auth/auth_button.dart';
import 'package:road_damage/view/widgets/auth/auth_text_from_field.dart';
import 'package:road_damage/view/widgets/auth/container_under.dart';
import 'package:road_damage/view/widgets/auth/social_button.dart';
import 'package:road_damage/view/widgets/dark_button.dart';
import 'package:road_damage/view/widgets/language_widget.dart';
import 'package:road_damage/view/widgets/loading_widget.dart';

import '../../widgets/text_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fromKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return controller.isLoad
          ? const LoadingScreen()
          : SafeArea(
              child: Scaffold(
                  backgroundColor: context.theme.backgroundColor,
                  appBar: AppBar(
                    backgroundColor:
                        Get.isDarkMode ? darkGreyClr : Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    actions: [
                      // ignore: prefer_const_constructors
                      DarkButton(),
                      LanguageButton()
                    ],
                    elevation: 0,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 0,
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
                                        text: "Sign ".tr,
                                        color: Get.isDarkMode
                                            ? darkColor2
                                            : mainColor,
                                        underLine: TextDecoration.none,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      TextUtils(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
                                        text: "in".tr,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        underLine: TextDecoration.none,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Expanded(
                                    flex: 0,
                                    child: AuthTextFromField(
                                      controller: emailController,
                                      obscureText: false,
                                      validator: (value) {
                                        if (!RegExp(validationEmail)
                                            .hasMatch(value)) {
                                          return "Invalid email".tr;
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
                                  GetBuilder<AuthController>(builder: (_) {
                                    return AuthTextFromField(
                                      controller: passwordController,
                                      obscureText: controller.isVisibility
                                          ? false
                                          : true,
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
                                  }),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.forgetPassScreen);
                                      },
                                      child: TextUtils(
                                        text: 'Forgot Password?'.tr,
                                        fontSize: 14,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        underLine: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AuthButton(
                                    onPressed: () {
                                      if (fromKey.currentState!.validate()) {
                                        String email =
                                            emailController.text.trim();
                                        String password =
                                            passwordController.text;
                                        if (networkManager.connectionType ==
                                            0) {
                                          Get.snackbar(
                                            'Error !'.tr,
                                            'Failed connect to internet'.tr,
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  "assets/icons/no-connection.png"),
                                              color: Colors.red,
                                            ),
                                          );
                                        } else {
                                          controller.signInwithAws(
                                              email: email, password: password);
                                        }
                                      }
                                    },
                                    text: "LOG IN".tr,
                                    // );}
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SocialButton(
                                      onPressed: controller.googleSinUpApp,
                                      text: "Sign in with Google".tr),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
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
                      text: "Don't have an Account? ".tr,
                      textType: "Sign up".tr,
                      onPressed: () {
                        Get.offNamed(Routes.signUpScreen);
                      },
                    ),
                  )),
            );
    });
  }
}
