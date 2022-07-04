import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/utilis/theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(color: Get.isDarkMode ? darkColor2 : mainColor)
        ],
      ),
    );
  }
}
