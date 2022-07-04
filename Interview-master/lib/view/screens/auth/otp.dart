import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:road_damage/logic/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/network_controller.dart';
import 'package:road_damage/view/widgets/loading_widget.dart';
import 'package:road_damage/view/widgets/text_utils.dart';

import '../../../utilis/theme.dart';
// // ignore: camel_case_types

// ignore: camel_case_types
class confirmSignUpScreen extends StatefulWidget {
  final String email;
  const confirmSignUpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _confirmSignUpScreenState createState() => _confirmSignUpScreenState();
}

// ignore: camel_case_types
class _confirmSignUpScreenState extends State<confirmSignUpScreen> {
  final controller = Get.find<AuthController>();
  final networkManager = Get.find<GetXNetworkManager>();

  final email = Get.arguments['email'];
  final password = Get.arguments['password'];

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
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                      Text(
                        'Verification'.tr,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? darkColor2 : mainColor),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Text(
                        "Enter your confirmation code number".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : darkGreyClr),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Pinput(
                          length: 6,
                          onCompleted: (pin) {
                            if (networkManager.connectionType == 0) {
                              Get.snackbar(
                                  'Error !'.tr, 'Failed connect to internet'.tr,
                                  icon: const ImageIcon(
                                    AssetImage(
                                        "assets/icons/no-connection.png"),
                                    color: Colors.red,
                                  ));
                            } else {
                              controller.confirmSignUp(
                                  email: email,
                                  password: password,
                                  confirmationCode: pin);
                            }
                          }),
                      SizedBox(
                        height: height * 0.22,
                      ),
                      Text(
                        "Didn't you receive any code?".tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Get.isDarkMode ? Colors.white : darkGreyClr),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * 0.001,
                      ),
                      TextButton(
                        onPressed: () {
                          controller.resendSignUpCode(email: email);
                        },
                        child: TextUtils(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          text: 'Resend New Code'.tr,
                          color: Get.isDarkMode ? darkColor2 : mainColor,
                          underLine: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
