import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:road_damage/utilis/my_string.dart';

import 'maps/textFieldController.dart';

class LanguageController extends GetxController {
  TextFieldController tc = Get.put(TextFieldController());
  var switchValue = false.obs;
  var storage = GetStorage();
  var langLocal = ene;
  late bool isLang = false;
  String capitalize(String profileName) {
    return profileName.split(" ").map((name) => name.capitalize).join(" ");
  }

  //Language
  @override
  void onInit() async {
    super.onInit();
    String language = await getLanguage;
    if (language != ene) {
      tc.changeTextEditingControllersToArabic();
      isLang = true;
    } else {
      tc.changeTextEditingControllersToEnglish();
      isLang = false;
    }
    update();
  }

  void saveLanguage(String lang) async {
    await storage.write("lang", lang);
  }

  Future<String> get getLanguage async {
    return await storage.read("lang") ??
        Get.deviceLocale.toString().substring(0, 2);
  }

  void changeIsLang(bool lang) {
    isLang = lang;
    update();
  }

  void changeLanguage() {
    isLang = !isLang;
    if (isLang) {
      langLocal = ara;
      saveLanguage(ara);
      Get.updateLocale(Locale(ara));
      tc.changeTextEditingControllersToArabic();
    } else {
      langLocal = ene;
      saveLanguage(ene);
      Get.updateLocale(Locale(ene));
      tc.changeTextEditingControllersToEnglish();
    }
    update();
  }
}
