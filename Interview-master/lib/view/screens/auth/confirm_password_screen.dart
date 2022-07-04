import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/utilis/theme.dart';
import 'package:road_damage/view/widgets/auth/auth_text_from_field.dart';
import 'package:road_damage/view/widgets/loading_widget.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

// // ignore: camel_case_types
// ignore: camel_case_types
class confirmPasswordScreen extends StatefulWidget {
  final String email;
  const confirmPasswordScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<confirmPasswordScreen> createState() => _confirmPasswordScreenState();
}

// ignore: camel_case_types
class _confirmPasswordScreenState extends State<confirmPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  final email = Get.arguments['email'];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<AuthController>(builder: (_) {
      return controller.isLoad
          ? const LoadingScreen()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: context.theme.backgroundColor,
              appBar: AppBar(
                backgroundColor: Get.isDarkMode ? darkGreyClr : Colors.white,
                centerTitle: true,
                elevation: 1,
                title: Text(
                  'Change password'.tr,
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
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
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
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          width: height * 0.2,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/icons/verification-email.png',
                          ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        GetBuilder<AuthController>(builder: (_) {
                          return AuthTextFromField(
                            controller: passwordController,
                            obscureText: controller.isVisibility ? false : true,
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
                        SizedBox(
                          height: height * 0.04,
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
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Pinput(
                          length: 6,
                          onCompleted: (pin) {
                            if (fromKey.currentState!.validate()) {
                              String password = passwordController.text;
                              (networkManager.connectionType == 0)
                                  ? Get.snackbar(
                                      'Error !'.tr,
                                      'Failed connect to internet'.tr,
                                      icon: const ImageIcon(
                                        AssetImage(
                                            "assets/icons/no-connection.png"),
                                        color: Colors.red,
                                      ),
                                    )
                                  : controller.confirmPassword(
                                      email: email,
                                      newPassword: password,
                                      confirmationCode: pin);
                            }
                          },
                        ),
                        SizedBox(
                          height: height * 0.17,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Text(
                                "Didn't you receive any code?".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Get.isDarkMode ? darkColor : mainColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.resetPassword(
                                    email: email,
                                  );
                                },
                                child: TextUtils(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  text: 'Resend New Code'.tr,
                                  color:
                                      Get.isDarkMode ? darkColor2 : mainColor,
                                  underLine: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ),
            );
    });
  }
}
