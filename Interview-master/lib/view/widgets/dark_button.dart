import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/logic/controller/theme_controller.dart';
import 'package:road_damage/utilis/theme.dart';

class DarkButton extends StatelessWidget {
  const DarkButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ThemeController().changesTheme();
        },
        icon: Icon(
          Get.isDarkMode ? Icons.dark_mode : Icons.lightbulb_outline,
          color: Get.isDarkMode ? darkColor2 : mainColor,
        ));
  }
}
