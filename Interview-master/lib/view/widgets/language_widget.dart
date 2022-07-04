import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/Language_controller.dart';
import 'package:road_damage/utilis/theme.dart';

class LanguageButton extends StatelessWidget {
  LanguageButton({Key? key}) : super(key: key);

  final controller = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
        builder: (_) => TextButton(
            onPressed: () {
              controller.changeLanguage();
            },
            child: Text(
              controller.isLang ? 'EN' : 'AR',
              style: TextStyle(color: Get.isDarkMode ? darkColor2 : mainColor),
            )));
  }
}
