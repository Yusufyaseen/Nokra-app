import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:road_damage/utilis/theme.dart';

class NetworkFailedScreen extends StatelessWidget {
  const NetworkFailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Get.isDarkMode ? darkGreyClr : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            const AssetImage("assets/icons/no-connection.png"),
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text('Internet connection failed'),
        ],
      ),
    );
  }
}
