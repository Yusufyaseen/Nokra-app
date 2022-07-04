// ignore_for_file: unused_import

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:road_damage/routes/routes.dart';

import 'maps/markerController.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  bool isVisibility = false;
  bool isCheckBox = false;
  var auth = Amplify.Auth;
  bool isSignIn = false;
  bool isLoad = false;
  bool admin = false;
  List adminEmail = [
    'mustafafich@gmail.com',
    'yousefkhaled2899@gmail.com',
    'mustafafich@gmail.com'
  ];
  void visibility() {
    isVisibility = !isVisibility;
    update();
  }

  void checkBox() {
    isCheckBox = !isCheckBox;
    update();
  }

  void isAdmin(String email) {
    for (int i = 0; i < adminEmail.length; i++) {
      if (email == adminEmail[i]) {
        admin = true;
      }
    }
    box.write('isAdmin', admin);
    update();
  }

  void signInwithAws({
    required String email,
    required String password,
  }) async {
    try {
      isLoad = !isLoad;
      update();
      await auth.signIn(
        username: email,
        password: password,
      );
      isSignIn = true;
      box.write('signIN', isSignIn);
      isAdmin(email);
      Get.offAndToNamed(Routes.maps);
      isLoad = !isLoad;
      update();
    } on AuthException {
      isLoad = !isLoad;
      update();
      Get.snackbar(
        'Login Failed !'.tr,
        'Invalid email'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
    // }
  }

  void signUpUsingAws({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      Map<String, String> userAttributes = {
        'email': email,
        'name': name
        // 'phone_number': '+15559101234',
        // additional attributes as needed
      };
      await auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      update();
      Get.offAndToNamed(Routes.verificationScreen,
          arguments: {'email': email, 'password': password});
      //  Get.offNamed(Routes.splashScreen,
      //                       arguments: {'routeName': '/signUpScreen'});
    } on AuthException {
      Get.snackbar(
        'error !'.tr,
        'email is invalid'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }

  void confirmSignUp({
    required String email,
    required String password,
    required String confirmationCode,
  }) async {
    try {
      isLoad = !isLoad;
      update();
      await auth.confirmSignUp(
          username: email, confirmationCode: confirmationCode);
      await auth.signIn(
        username: email,
        password: password,
      );
      isSignIn = true;
      box.write('signIN', isSignIn);
      isAdmin(email);
      isLoad = !isLoad;
      update();
      Get.offAndToNamed(Routes.maps);
    } on AuthException {
      isLoad = !isLoad;
      update();
      Get.snackbar(
        'error !'.tr,
        'confirmation code incorrect'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }

  void resendSignUpCode({required String email}) async {
    try {
      await auth.resendSignUpCode(username: email);
      update();
    } on AuthException catch (e) {
      Get.snackbar(
        'error !'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }

  void resetPassword({required String email}) async {
    try {
      await auth.resetPassword(username: email);
      update();
      Get.offAndToNamed(Routes.confirmPasswordScreen,
          arguments: {'email': email});
    } on AuthException {
      Get.snackbar(
        'error !'.tr,
        'email is invalid'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }

  void confirmPassword(
      {required String email,
      required String newPassword,
      required String confirmationCode}) async {
    try {
      isLoad = !isLoad;
      update();
      await auth.confirmResetPassword(
          username: email,
          newPassword: newPassword,
          confirmationCode: confirmationCode);
      await auth.signIn(
        username: email,
        password: newPassword,
      );
      isSignIn = true;
      box.write('signIN', isSignIn);
      isAdmin(email);
      isLoad = !isLoad;
      update();
      Get.offAndToNamed(Routes.maps);
    } on AuthException catch (e) {
      isLoad = !isLoad;
      update();
      Get.snackbar(
        'error !',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }

  void googleSinUpApp() async {
    try {
      isLoad = !isLoad;
      update();
      await auth.signInWithWebUI(provider: AuthProvider.google);
      isSignIn = true;
      box.write('signIN', isSignIn);
      box.write('isAdmin', false);

      Get.offAndToNamed(Routes.maps);
      isLoad = !isLoad;
      update();
    } on AuthException catch (e) {
      isLoad = !isLoad;
      update();
      Get.snackbar(
        'error !',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
      // print(e.message);
    }
  }

  void signout() async {
    try {
      await auth.signOut();
      isSignIn = false;
      box.write('signIN', isSignIn);
      update();
      Get.offNamed(Routes.welcomeScreen);
    } on AmplifyException catch (e) {
      Get.snackbar(
        'error !',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 233, 195, 195),
        colorText: const Color.fromARGB(255, 189, 23, 23),
      );
    }
  }
}
