import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:road_damage/logic/controller/Language_controller.dart';

class ArrowBack extends StatelessWidget {
  ArrowBack({Key? key}) : super(key: key);
  final languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
        builder: (_) => languageController.isLang
            ? const Icon(Icons.arrow_back_ios, textDirection: TextDirection.ltr)
            : const Icon(Icons.arrow_back_ios,
                textDirection: TextDirection.rtl));
  }
}
